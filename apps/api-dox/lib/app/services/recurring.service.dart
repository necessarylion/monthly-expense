import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/dtos/recurring/recurring.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/group.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/repositories/recurring_expense.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:dox_core/dox_core.dart';

/// Expenses that repeat every month. The scheduler calls [runDue]; each
/// due row adds a normal expense and moves on one month.
@Inject()
class RecurringService {
  RecurringService(
    this.recurring,
    this.expenses,
    this.categories,
    this.accounts,
    this.users,
    this.groups,
    this.members,
  );

  final RecurringExpenseRepository recurring;
  final ExpenseService expenses;
  final CategoryService categories;
  final AccountService accounts;
  final UserRepository users;
  final GroupRepository groups;
  final GroupMemberRepository members;

  Future<List<RecurringExpense>> list(Group group) {
    return recurring.listByGroup(group.id!);
  }

  /// Saves it, then adds today's expense at once when today is its day.
  Future<RecurringExpense> create(
    User user,
    Group group,
    CreateRecurring input,
  ) async {
    if (group.isTrip) {
      throw HttpError.unprocessable('A trip group has no recurring expenses');
    }
    Category category = await categories.assertInGroup(group, input.categoryId);
    if (input.accountId != null) await accounts.find(user, input.accountId!);
    if (await recurring.countByGroup(group.id!) >= recurringPerGroupMax) {
      throw HttpError.unprocessable(
        'A group can have at most $recurringPerGroupMax recurring expenses',
      );
    }
    RecurringExpense row = await recurring.create(<String, dynamic>{
      'group_id': group.id,
      'created_by_user_id': user.id,
      'category_id': category.id,
      'account_id': input.accountId,
      'amount_cents': MoneyUtil.toCents(input.amount),
      'note': input.note,
      'day_of_month': input.dayOfMonth,
      'next_on': firstRunOn(DateUtil.today(), input.dayOfMonth),
    });
    await _run(row, DateUtil.today());
    return (await recurring.findById(row.id!))!;
  }

  Future<RecurringExpense> find(Group group, int id) async {
    RecurringExpense? row = await recurring.findById(id);
    if (row == null || row.groupId != group.id) {
      throw HttpError.notFound('Recurring expense not found');
    }
    return row;
  }

  /// Expenses it already added stay.
  Future<void> delete(RecurringExpense row) => recurring.delete(row.id!);

  /// Adds every expense that is due by today. Months the server missed
  /// are added too, each on its own date.
  Future<int> runDue() async {
    String today = DateUtil.today();
    int added = 0;
    for (RecurringExpense row in await recurring.listDue(today)) {
      added += await _run(row, today);
    }
    return added;
  }

  Future<int> _run(RecurringExpense row, String today) async {
    int added = 0;
    String on = row.nextOn;
    while (on.compareTo(today) <= 0) {
      String next = nextRunOn(on, row.dayOfMonth);
      // Another run moved it first: that run adds this one.
      if (!await recurring.claim(row.id!, on, next)) return added;
      if (await _addExpense(row, on)) added++;
      on = next;
    }
    return added;
  }

  /// False when it could not add one (the category, the user or the
  /// group is gone, the user left the group, the group is a trip, or the
  /// wallet can not be used). The month is skipped.
  Future<bool> _addExpense(RecurringExpense row, String on) async {
    if (row.categoryId == null || row.createdByUserId == null) return false;
    User? user = await users.findById(row.createdByUserId!);
    Group? group = await groups.findById(row.groupId);
    // A trip has no months, so nothing repeats in it.
    if (user == null || group == null || group.isTrip) return false;
    // The creator left the group: stop adding in their name.
    if (await members.findJoined(group.id!, user.id!) == null) return false;
    try {
      await expenses.create(
        user,
        group,
        CreateExpense(
          categoryId: row.categoryId!,
          amount: MoneyUtil.fromCents(row.amountCents),
          occurredOn: on,
          note: row.note,
          accountId: row.accountId == null
              ? const Maybe<int?>.missing()
              : Maybe<int?>(row.accountId),
        ),
      );
      return true;
    } catch (error) {
      Logger.warn('[recurring] ${row.id} on $on: $error');
      return false;
    }
  }

  /// The first date on or after [today] that falls on [day].
  static String firstRunOn(String today, int day) {
    int year = int.parse(today.substring(0, 4));
    int month = int.parse(today.substring(5, 7));
    String candidate = dateOn(year, month, day);
    if (candidate.compareTo(today) >= 0) return candidate;
    return dateOn(year, month + 1, day);
  }

  /// The run one month after [date].
  static String nextRunOn(String date, int day) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(5, 7));
    return dateOn(year, month + 1, day);
  }

  /// [day] of the month, or its last day when the month is shorter.
  /// [month] may be 13 (January of the next year).
  static String dateOn(int year, int month, int day) {
    DateTime first = DateTime.utc(year, month);
    int lastDay = DateTime.utc(first.year, first.month + 1, 0).day;
    int d = day < lastDay ? day : lastDay;
    return '${first.year.toString().padLeft(4, '0')}-'
        '${first.month.toString().padLeft(2, '0')}-'
        '${d.toString().padLeft(2, '0')}';
  }
}
