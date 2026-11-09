import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/serializers/expense.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Expenses'])
class ExpenseController {
  ExpenseController(this.expenses);

  final ExpenseService expenses;

  @Summary('List expenses')
  @Description(
    'The active group\'s expenses for `?month=YYYY-MM` (default: this month).',
  )
  Future<Map<String, dynamic>> index(DoxRequest req, MonthQuery query) async {
    List<ExpenseWithCategory> rows = await expenses.listForMonth(
      req.activeGroup,
      MonthUtil.parse(query.month),
    );
    return JsonResponse.ok(ExpenseSerializer(rows).toJson());
  }

  @Summary('Frequent expenses')
  @Description('Expenses this group logs again and again, for one-tap adds.')
  Future<Map<String, dynamic>> frequent(DoxRequest req) async {
    List<FrequentExpense> rows = await expenses.frequent(req.activeGroup);
    return JsonResponse.ok(<Map<String, dynamic>>[
      for (FrequentExpense row in rows) row.toJson(),
    ]);
  }

  @Summary('Monthly summary')
  @Description('Totals for a month, overall and per category.')
  Future<Map<String, dynamic>> summary(DoxRequest req, MonthQuery query) async {
    MonthlySummary summary = await expenses.summary(
      req.activeGroup,
      MonthUtil.parse(query.month),
    );
    return JsonResponse.ok(summary.toJson());
  }

  @Summary('Create an expense')
  @Description(
    'The money also leaves a wallet: the default one, unless `accountId` is given.',
  )
  @Response(201, null, description: 'Created')
  Future<DoxResponse> store(DoxRequest req, CreateExpense body) async {
    ExpenseWithCategory row = await expenses.create(
      req.authUser,
      req.activeGroup,
      body,
    );
    return JsonResponse.created(ExpenseSerializer(row).toJson());
  }

  @Summary('Update an expense')
  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateExpense body,
  ) async {
    Expense expense = await expenses.find(req.activeGroup, id);
    ExpenseWithCategory row = await expenses.update(
      req.activeGroup,
      expense,
      body,
    );
    return JsonResponse.ok(ExpenseSerializer(row).toJson());
  }

  @Summary('Delete an expense')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    Expense expense = await expenses.find(req.activeGroup, id);
    await expenses.delete(expense);
    return JsonResponse.noContent();
  }
}
