import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/serializers/expense.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/app/services/report.service.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Expenses'])
class ExpenseController {
  ExpenseController(this.expenses, this.reports);

  final ExpenseService expenses;
  final ReportService reports;

  @Summary('Search expenses')
  @Description(
    'Expenses that match every filter, newest first, at most 2000. `q` '
    'matches the note or the category name.',
  )
  Future<Map<String, dynamic>> search(DoxRequest req, SearchQuery query) async {
    List<ExpenseWithCategory> rows = await expenses.search(
      req.activeGroup,
      query,
    );
    return JsonResponse.ok(ExpenseSerializer(rows).toJson());
  }

  @Summary('Yearly summary')
  @Description('Totals for `?year=YYYY`, per month and per category.')
  Future<Map<String, dynamic>> year(DoxRequest req, YearQuery query) async {
    int year = query.year ?? int.parse(DateUtil.today().substring(0, 4));
    YearlySummary summary = await reports.yearly(req.activeGroup, year);
    return JsonResponse.ok(summary.toJson());
  }

  @Summary('Who owes whom')
  @Description(
    'For `?month=YYYY-MM`: what each member paid, their equal share, and '
    'the payments that settle the month.',
  )
  Future<Map<String, dynamic>> balances(
    DoxRequest req,
    MonthQuery query,
  ) async {
    MonthBalances balances = await reports.balances(
      req.activeGroup,
      MonthUtil.parse(query.month),
    );
    return JsonResponse.ok(balances.toJson());
  }

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
