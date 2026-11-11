import 'dart:async';

import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/ai/expense_categorizer.dart';
import 'package:api_dox/app/services/ai/quick_add_picker.dart';
import 'package:api_dox/app/services/budget.service.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

class ExpenseWithCategory {
  final Expense expense;
  final Category? category;

  const ExpenseWithCategory(this.expense, this.category);
}

class CategoryTotal {
  final int? categoryId;
  int totalCents = 0;
  int count = 0;

  CategoryTotal(this.categoryId);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'totalCents': totalCents,
      'count': count,
    };
  }
}

class MonthlySummary {
  final String month;
  final int totalCents;
  final int count;
  final int? monthlyBudgetCents;
  final List<CategoryTotal> byCategory;

  const MonthlySummary({
    required this.month,
    required this.totalCents,
    required this.count,
    required this.monthlyBudgetCents,
    required this.byCategory,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'month': month,
      'totalCents': totalCents,
      'count': count,
      'monthlyBudgetCents': monthlyBudgetCents,
      'byCategory': <Map<String, dynamic>>[
        for (CategoryTotal row in byCategory) row.toJson(),
      ],
    };
  }
}

@Inject()
class ExpenseService {
  ExpenseService(
    this.expenses,
    this.categories,
    this.budgets,
    this.accounts,
    this.live,
    this.quickAdds,
    this.categorizer,
  );

  final ExpenseRepository expenses;
  final CategoryService categories;
  final BudgetService budgets;
  final AccountService accounts;
  final LiveService live;
  final QuickAddPicker quickAdds;
  final ExpenseCategorizer categorizer;

  /// The month's expenses with their category, newest first.
  Future<List<ExpenseWithCategory>> listForMonth(
    Group group,
    MonthRange month,
  ) async {
    month = MonthUtil.forGroup(group.isTrip, month);
    List<Expense> rows = await expenses.listInRange(
      group.id!,
      month.start,
      month.end,
    );
    await expenses.attachWalletOwners(rows);
    Map<int, Category> byId = await categories.mapForGroup(group);
    return <ExpenseWithCategory>[
      for (Expense expense in rows)
        ExpenseWithCategory(
          expense,
          expense.categoryId == null ? null : byId[expense.categoryId],
        ),
    ];
  }

  /// What this group logs again and again lately; the app shows these as
  /// one-tap adds. Claude picks them and merges near-duplicates.
  Future<List<FrequentExpense>> frequent(Group group) async {
    String since = DateUtil.addDays(DateUtil.today(), -frequentExpenseDays);
    List<FrequentExpense> candidates = await expenses.frequent(
      group.id!,
      since,
      frequentExpenseMinUses,
      frequentCandidateLimit,
    );
    Map<int, String> names = <int, String>{
      for (Category category in await categories.list(group))
        category.id!: category.name,
    };
    return quickAdds.pick(group.id!, candidates, names);
  }

  Future<MonthlySummary> summary(Group group, MonthRange month) async {
    month = MonthUtil.forGroup(group.isTrip, month);
    List<Expense> rows = await expenses.listInRange(
      group.id!,
      month.start,
      month.end,
    );
    Map<int?, CategoryTotal> byCategory = <int?, CategoryTotal>{};
    int totalCents = 0;
    for (Expense expense in rows) {
      totalCents += expense.amountCents;
      CategoryTotal row = byCategory.putIfAbsent(
        expense.categoryId,
        () => CategoryTotal(expense.categoryId),
      );
      row.totalCents += expense.amountCents;
      row.count += 1;
    }
    // A stable sort, like JavaScript's: equal totals keep their order.
    List<CategoryTotal> sorted = byCategory.values.toList();
    stableSortByTotalDesc(sorted);
    return MonthlySummary(
      month: month.key,
      totalCents: totalCents,
      count: rows.length,
      monthlyBudgetCents: await budgets.getForMonth(group, month.key),
      byCategory: sorted,
    );
  }

  Future<Expense> find(Group group, int? id) async {
    Expense? expense = id == null ? null : await expenses.findById(id);
    if (expense == null || expense.groupId != group.id) {
      throw HttpError.notFound('Expense not found');
    }
    return expense;
  }

  /// Same as [find], but returns null instead of throwing.
  Future<Expense?> findOrNull(Group group, int id) async {
    Expense? expense = await expenses.findById(id);
    return expense != null && expense.groupId == group.id ? expense : null;
  }

  Future<ExpenseWithCategory> create(
    User user,
    Group group,
    CreateExpense input,
  ) async {
    String? note = input.note;
    if (input.categoryId == null && note == null) {
      throw HttpError.unprocessable('Write a note, or pick a category.');
    }
    // No category: the same note's category from before, else Claude's
    // pick, made after the answer is sent.
    Category? category = input.categoryId != null
        ? await categories.assertInGroup(group, input.categoryId)
        : await _fromHistory(group, note!);
    // Fail on a bad account before the expense row exists.
    int? accountId = input.accountId.isPresent ? input.accountId.value : null;
    if (accountId != null) await accounts.find(user, accountId);

    Expense expense = await expenses.create(
      groupId: group.id!,
      createdByUserId: user.id,
      categoryId: category?.id,
      amountCents: MoneyUtil.toCents(input.amount),
      occurredOn: input.occurredOn,
      note: note,
    );
    await accounts.recordExpenseOutflow(
      user,
      expense,
      category,
      hasAccountId: input.accountId.isPresent,
      accountId: accountId,
    );
    await expenses.attachWalletOwners(<Expense>[expense]);
    await _changed(expense);
    if (category == null) _sortLater(group, expense);
    return ExpenseWithCategory(expense, category);
  }

  Future<ExpenseWithCategory> update(
    Group group,
    Expense expense,
    UpdateExpense input,
  ) async {
    Map<String, dynamic> changes = <String, dynamic>{};
    bool sort = false;
    String? newNote = input.note.isPresent ? input.note.value : null;
    if (input.categoryId != null) {
      changes['category_id'] = (await categories.assertInGroup(
        group,
        input.categoryId,
      )).id;
    } else if (newNote != null && newNote != expense.note) {
      // A new note with no category: sort it again, like a new expense.
      Category? known = await _fromHistory(group, newNote);
      if (known != null) {
        changes['category_id'] = known.id;
      } else {
        sort = true;
      }
    }
    if (input.amount != null) {
      changes['amount_cents'] = MoneyUtil.toCents(input.amount!);
    }
    if (input.occurredOn != null) changes['occurred_on'] = input.occurredOn;
    if (input.note.isPresent) changes['note'] = input.note.value;

    Expense updated = changes.isNotEmpty
        ? await expenses.update(expense.id!, changes)
        : expense;
    Category? category = updated.categoryId == null
        ? null
        : await categories.findInGroup(group, updated.categoryId);
    await accounts.syncExpenseOutflow(updated, category);
    await expenses.attachWalletOwners(<Expense>[updated]);
    await _changed(updated);
    if (sort) _sortLater(group, updated);
    return ExpenseWithCategory(updated, category);
  }

  /// Expenses that match the query, newest first. The text matches the
  /// note or the category name.
  Future<List<ExpenseWithCategory>> search(
    Group group,
    SearchQuery query,
  ) async {
    Map<int, Category> byId = await categories.mapForGroup(group);
    String? text = query.q;
    List<int> textCategoryIds = <int>[];
    if (text != null) {
      String lower = text.toLowerCase();
      for (Category category in byId.values) {
        if (category.name.toLowerCase().contains(lower)) {
          textCategoryIds.add(category.id!);
        }
      }
    }
    List<Expense> rows = await expenses.search(
      groupId: group.id!,
      text: text,
      textCategoryIds: textCategoryIds,
      categoryId: query.categoryId,
      from: query.from,
      to: query.to,
      limit: searchResultLimit,
    );
    await expenses.attachWalletOwners(rows);
    return <ExpenseWithCategory>[
      for (Expense expense in rows)
        ExpenseWithCategory(
          expense,
          expense.categoryId == null ? null : byId[expense.categoryId],
        ),
    ];
  }

  /// The booked account entry goes with it (the foreign key cascades), so
  /// its wallet is found first.
  Future<void> delete(Expense expense) async {
    int? accountId = await live.accountOfExpense(expense.id!);
    await expenses.delete(expense.id!);
    await live.expenseChanged(expense.groupId, accountId);
  }

  /// The category of the group's last expense with this note.
  Future<Category?> _fromHistory(Group group, String note) async {
    int? id = await categorizer.fromHistory(group.id!, note);
    return id == null ? null : categories.findInGroup(group, id);
  }

  /// Asks Claude for the expense's category without holding up the answer.
  /// The app gets a `changed` event when it is set.
  void _sortLater(Group group, Expense expense) {
    if (!categorizer.enabled || expense.note == null) return;
    unawaited(sortWithAi(group, expense.id!, expense.note!));
  }

  /// Sets the category Claude picks for the note. It keeps the expense as
  /// it is when the note or the category changed in the meantime.
  Future<void> sortWithAi(Group group, int id, String note) async {
    try {
      Expense? before = await expenses.findById(id);
      if (before == null || before.note != note) return;
      int? pick = await categorizer.ask(
        note,
        before.amountCents,
        await categories.list(group),
      );
      if (pick == null || pick == before.categoryId) return;
      Expense? now = await expenses.findById(id);
      if (now == null ||
          now.note != note ||
          now.categoryId != before.categoryId) {
        return;
      }
      await _changed(
        await expenses.update(id, <String, dynamic>{'category_id': pick}),
      );
    } catch (error) {
      Logger.warn('[categorize] expense $id: $error');
    }
  }

  /// Tell the group, and the wallet the expense is booked in.
  Future<void> _changed(Expense expense) async {
    await live.expenseChanged(
      expense.groupId,
      await live.accountOfExpense(expense.id!),
    );
  }

  /// Insertion sort: stable, and the lists are short (one row per category).
  static void stableSortByTotalDesc(List<CategoryTotal> rows) {
    for (int i = 1; i < rows.length; i++) {
      CategoryTotal current = rows[i];
      int j = i - 1;
      while (j >= 0 && rows[j].totalCents < current.totalCents) {
        rows[j + 1] = rows[j];
        j--;
      }
      rows[j + 1] = current;
    }
  }
}
