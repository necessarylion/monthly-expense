import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/app/mcp/app_tool.dart';
import 'package:api_dox/app/serializers/expense.serializer.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

@Inject()
class AddExpenseTool extends AppTool<CreateExpense> {
  AddExpenseTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'add_expense';

  @override
  String get description =>
      'Record a new expense in the given group. Give a note; categoryId '
      '(see list_categories) is optional: left out, it is picked from the '
      'note shortly after. Amount is in dollars (e.g. 12.50). The money also '
      'leaves a wallet: your default one, unless accountId is given. '
      'Returns the expense; amountCents is in cents.';

  @override
  DtoSchema<CreateExpense> get dto => CreateExpense.schema;

  @override
  Future<McpToolResult> run(CreateExpense input, User user) async {
    Group group = await groupOf(user, input.groupId);
    ExpenseWithCategory row = await expenses.create(user, group, input);
    return AppTool.json(<String, dynamic>{
      'currency': group.currency,
      'expense': ExpenseSerializer(row).toJson(),
    });
  }
}

@Inject()
class ListExpensesTool extends AppTool<MonthQuery> {
  ListExpensesTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'list_expenses';

  @override
  String get description =>
      'List expenses in the given group for a given month (defaults to the '
      'current month). amountCents is in cents.';

  @override
  DtoSchema<MonthQuery> get dto => MonthQuery.schema;

  @override
  Future<McpToolResult> run(MonthQuery input, User user) async {
    Group group = await groupOf(user, input.groupId);
    MonthRange month = MonthUtil.parse(input.month);
    List<ExpenseWithCategory> rows = await expenses.listForMonth(group, month);
    return AppTool.json(<String, dynamic>{
      'month': month.key,
      'currency': group.currency,
      'expenses': ExpenseSerializer(rows).toJson(),
    });
  }
}

@Inject()
class FrequentExpensesTool extends AppTool<GroupRef> {
  FrequentExpensesTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'frequent_expenses';

  @override
  String get description =>
      'Expenses this group logs again and again (the quick-add chips of the '
      'app). Amounts are in cents.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    List<FrequentExpense> rows = await expenses.frequent(group);
    return AppTool.json(<String, dynamic>{
      'currency': group.currency,
      'frequent': <Map<String, dynamic>>[
        for (FrequentExpense row in rows) row.toJson(),
      ],
    });
  }
}

@Inject()
class UpdateExpenseTool extends AppTool<UpdateExpense> {
  UpdateExpenseTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'update_expense';

  @override
  String get description =>
      'Update an existing expense in the given group. Only include the '
      'fields you want to change. Find expense IDs via list_expenses.';

  @override
  DtoSchema<UpdateExpense> get dto => UpdateExpense.schema;

  @override
  Future<McpToolResult> run(UpdateExpense input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int id = AppTool.need(input.id, 'id');
    Expense? expense = await expenses.findOrNull(group, id);
    if (expense == null) {
      return AppTool.error('Expense $id not found in group "${group.name}".');
    }
    if (input.categoryId == null &&
        input.amount == null &&
        input.occurredOn == null &&
        !input.note.isPresent) {
      return AppTool.text('No changes provided for expense $id.');
    }

    ExpenseWithCategory row = await expenses.update(group, expense, input);
    return AppTool.json(<String, dynamic>{
      'currency': group.currency,
      'expense': ExpenseSerializer(row).toJson(),
    });
  }
}

@Inject()
class DeleteExpenseTool extends AppTool<GroupItemRef> {
  DeleteExpenseTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'delete_expense';

  @override
  String get description =>
      'Delete an expense in the given group. id is the expense ID (see '
      'list_expenses).';

  @override
  DtoSchema<GroupItemRef> get dto => GroupItemRef.schema;

  @override
  Future<McpToolResult> run(GroupItemRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    Expense? expense = await expenses.findOrNull(group, input.id);
    if (expense == null) {
      return AppTool.error(
        'Expense ${input.id} not found in group "${group.name}".',
      );
    }
    await expenses.delete(expense);
    return AppTool.text('Deleted expense ${input.id}.');
  }
}

@Inject()
class MonthlySummaryTool extends AppTool<MonthQuery> {
  MonthlySummaryTool(super.groups, this.categories, this.expenses);

  final CategoryService categories;
  final ExpenseService expenses;

  @override
  String get name => 'monthly_summary';

  @override
  String get description =>
      'Return totals (overall and per-category) for a month in the given '
      'group. Amounts are in cents.';

  @override
  DtoSchema<MonthQuery> get dto => MonthQuery.schema;

  @override
  Future<McpToolResult> run(MonthQuery input, User user) async {
    Group group = await groupOf(user, input.groupId);
    MonthlySummary summary = await expenses.summary(
      group,
      MonthUtil.parse(input.month),
    );
    Map<int, Category> names = await categories.mapForGroup(group);
    // The GET /summary shape, plus the category name on each row so the
    // model does not need list_categories.
    return AppTool.json(<String, dynamic>{
      ...summary.toJson(),
      'currency': group.currency,
      'byCategory': <Map<String, dynamic>>[
        for (CategoryTotal row in summary.byCategory)
          <String, dynamic>{
            ...row.toJson(),
            'categoryName': names[row.categoryId]?.name,
          },
      ],
    });
  }
}
