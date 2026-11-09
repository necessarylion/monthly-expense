import 'package:api_dox/app/dtos/recurring/recurring.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/serializers/recurring_expense.serializer.dart';
import 'package:api_dox/app/services/recurring.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Recurring expenses'])
class RecurringController {
  RecurringController(this.recurring);

  final RecurringService recurring;

  @Summary('List recurring expenses')
  @Description('The active group\'s monthly repeats, by day of the month.')
  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<RecurringExpense> rows = await recurring.list(req.activeGroup);
    return JsonResponse.ok(RecurringExpenseSerializer(rows).toJson());
  }

  @Summary('Add a recurring expense')
  @Description(
    'Adds a normal expense on `dayOfMonth` every month. When that day is '
    'today, today\'s expense is added at once.',
  )
  @Response(201, null, description: 'Created')
  Future<DoxResponse> store(DoxRequest req, CreateRecurring body) async {
    RecurringExpense row = await recurring.create(
      req.authUser,
      req.activeGroup,
      body,
    );
    return JsonResponse.created(RecurringExpenseSerializer(row).toJson());
  }

  @Summary('Delete a recurring expense')
  @Description('Expenses it already added stay.')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    await recurring.delete(await recurring.find(req.activeGroup, id));
    return JsonResponse.noContent();
  }
}
