import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/serializers/group.serializer.dart';
import 'package:api_dox/app/serializers/group_member.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/budget.service.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:dox_core/dox_core.dart';

/// Group routes take the group from the URL, not from X-Group-Id.
@Inject()
class GroupController {
  GroupController(this.groups, this.budgets);

  final GroupService groups;
  final BudgetService budgets;

  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<Group> list = await groups.listForUser(req.authUser);
    return JsonResponse.ok(GroupSerializer(list).toJson());
  }

  Future<DoxResponse> store(DoxRequest req, CreateGroup body) async {
    Group group = await groups.createForUser(
      req.authUser,
      name: body.name,
      currency: body.currency,
    );
    return JsonResponse.created(GroupSerializer(group).toJson());
  }

  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateGroup body,
  ) async {
    Group group = await _group(req, id);
    Group updated = await groups.update(
      group,
      name: body.name,
      currency: body.currency,
    );
    return JsonResponse.ok(GroupSerializer(updated).toJson());
  }

  Future<Map<String, dynamic>> setBudget(
    DoxRequest req,
    int id,
    SetBudget body,
  ) async {
    Group group = await _group(req, id);
    num? budget = body.budget.value;
    int? cents = budget == null ? null : MoneyUtil.toCents(budget);
    int? effective = await budgets.setForMonth(group, body.month, cents);
    return JsonResponse.ok(<String, dynamic>{
      'month': body.month,
      'monthlyBudgetCents': effective,
    });
  }

  Future<Map<String, dynamic>> members(DoxRequest req, int id) async {
    Group group = await _group(req, id);
    List<GroupMember> list = await groups.listMembers(group);
    return JsonResponse.ok(GroupMemberSerializer(list).toJson());
  }

  Future<DoxResponse> invite(DoxRequest req, int id, Invite body) async {
    Group group = await _group(req, id);
    GroupMember member = await groups.invite(group, req.authUser, body.email);
    return JsonResponse.created(GroupMemberSerializer(member).toJson());
  }

  Future<DoxResponse> removeMember(DoxRequest req, int id, int memberId) async {
    Group group = await _group(req, id);
    await groups.removeMember(group, memberId);
    return JsonResponse.noContent();
  }

  Future<DoxResponse> leave(DoxRequest req, int id) async {
    Group group = await _group(req, id);
    await groups.leave(group, req.authUser);
    return JsonResponse.noContent();
  }

  Future<Group> _group(DoxRequest req, int id) {
    return groups.assertMembership(req.authUser, id);
  }
}
