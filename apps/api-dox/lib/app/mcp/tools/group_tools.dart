import 'package:api_dox/app/dtos/account/account.dto.dart';
import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/budget.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/app/mcp/app_tool.dart';
import 'package:api_dox/app/serializers/group.serializer.dart';
import 'package:api_dox/app/serializers/group_member.serializer.dart';
import 'package:api_dox/app/serializers/user.serializer.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

@Inject()
class GetMeTool extends AppTool<NoInput> {
  GetMeTool(super.groups);

  @override
  String get name => 'get_me';

  @override
  String get description => 'Who the MCP user is: id, name and email.';

  @override
  DtoSchema<NoInput> get dto => NoInput.schema;

  @override
  Future<McpToolResult> run(NoInput input, User user) async {
    return AppTool.json(<String, dynamic>{
      'user': UserSerializer(user).toJson(),
    });
  }
}

@Inject()
class ListGroupsTool extends AppTool<NoInput> {
  ListGroupsTool(super.groups);

  @override
  String get name => 'list_groups';

  @override
  String get description =>
      'List all groups the MCP user belongs to. Use the returned IDs as the '
      'required groupId argument to other tools.';

  @override
  DtoSchema<NoInput> get dto => NoInput.schema;

  @override
  Future<McpToolResult> run(NoInput input, User user) async {
    List<Group> list = await groups.listForUser(user);
    return AppTool.json(<String, dynamic>{
      'groups': GroupSerializer(list).toJson(),
    });
  }
}

@Inject()
class CreateGroupTool extends AppTool<CreateGroup> {
  CreateGroupTool(super.groups);

  @override
  String get name => 'create_group';

  @override
  String get description =>
      'Create a new group with the MCP user as its first member. It starts '
      'with the default categories.';

  @override
  DtoSchema<CreateGroup> get dto => CreateGroup.schema;

  @override
  Future<McpToolResult> run(CreateGroup input, User user) async {
    Group group = await groups.createForUser(
      user,
      name: input.name,
      currency: input.currency,
    );
    return AppTool.json(<String, dynamic>{
      'group': GroupSerializer(group).toJson(),
    });
  }
}

@Inject()
class UpdateGroupTool extends AppTool<UpdateGroup> {
  UpdateGroupTool(super.groups);

  @override
  String get name => 'update_group';

  @override
  String get description =>
      'Rename a group or change its currency. Only include the fields you '
      'want to change.';

  @override
  DtoSchema<UpdateGroup> get dto => UpdateGroup.schema;

  @override
  Future<McpToolResult> run(UpdateGroup input, User user) async {
    Group group = await groupOf(user, input.groupId);
    if (input.name == null && input.currency == null) {
      return AppTool.text('No changes provided for group ${group.id}.');
    }
    Group updated = await groups.update(
      group,
      name: input.name,
      currency: input.currency,
    );
    return AppTool.json(<String, dynamic>{
      'group': GroupSerializer(updated).toJson(),
    });
  }
}

@Inject()
class ListGroupMembersTool extends AppTool<GroupRef> {
  ListGroupMembersTool(super.groups);

  @override
  String get name => 'list_group_members';

  @override
  String get description =>
      'List the members of a group, and the people invited who have not '
      'signed in yet.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    List<GroupMember> list = await groups.listMembers(group);
    return AppTool.json(<String, dynamic>{
      'members': GroupMemberSerializer(list).toJson(),
    });
  }
}

@Inject()
class InviteGroupMemberTool extends AppTool<Invite> {
  InviteGroupMemberTool(super.groups);

  @override
  String get name => 'invite_group_member';

  @override
  String get description =>
      'Invite a person to a group by their Gmail address.';

  @override
  DtoSchema<Invite> get dto => Invite.schema;

  @override
  Future<McpToolResult> run(Invite input, User user) async {
    Group group = await groupOf(user, input.groupId);
    GroupMember member = await groups.invite(group, user, input.email);
    return AppTool.json(<String, dynamic>{
      'member': GroupMemberSerializer(member).toJson(),
    });
  }
}

@Inject()
class RemoveGroupMemberTool extends AppTool<GroupMemberRef> {
  RemoveGroupMemberTool(super.groups);

  @override
  String get name => 'remove_group_member';

  @override
  String get description =>
      'Remove a member (or a pending invite) from a group. To leave a group '
      'yourself, use leave_group.';

  @override
  DtoSchema<GroupMemberRef> get dto => GroupMemberRef.schema;

  @override
  Future<McpToolResult> run(GroupMemberRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    await groups.removeMember(group, input.memberId);
    return AppTool.text(
      'Removed member ${input.memberId} from group "${group.name}".',
    );
  }
}

@Inject()
class LeaveGroupTool extends AppTool<GroupRef> {
  LeaveGroupTool(super.groups);

  @override
  String get name => 'leave_group';

  @override
  String get description =>
      'Leave a group. The MCP user loses access to its expenses.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    await groups.leave(group, user);
    return AppTool.text('Left group "${group.name}".');
  }
}

@Inject()
class GetBudgetTool extends AppTool<MonthQuery> {
  GetBudgetTool(super.groups, this.expenses);

  final ExpenseService expenses;

  @override
  String get name => 'get_budget';

  @override
  String get description =>
      'Get the effective monthly budget (carry-forward aware) plus spend and '
      'remaining for the month in the given group. Month defaults to the '
      'current month. Amounts are in cents.';

  @override
  DtoSchema<MonthQuery> get dto => MonthQuery.schema;

  @override
  Future<McpToolResult> run(MonthQuery input, User user) async {
    Group group = await groupOf(user, input.groupId);
    MonthlySummary summary = await expenses.summary(
      group,
      MonthUtil.parse(input.month),
    );
    int? budgetCents = summary.monthlyBudgetCents;
    return AppTool.json(<String, dynamic>{
      'month': summary.month,
      'currency': group.currency,
      'monthlyBudgetCents': budgetCents,
      'spentCents': summary.totalCents,
      'remainingCents': budgetCents == null
          ? null
          : budgetCents - summary.totalCents,
      'count': summary.count,
    });
  }
}

@Inject()
class SetBudgetTool extends AppTool<SetBudget> {
  SetBudgetTool(super.groups, this.budgets);

  final BudgetService budgets;

  @override
  String get name => 'set_budget';

  @override
  String get description =>
      'Set or clear the monthly budget of a month in the given group. Pass '
      'budget=null to remove the override for that month (it will then '
      'carry forward from the prior record).';

  @override
  DtoSchema<SetBudget> get dto => SetBudget.schema;

  @override
  Future<McpToolResult> run(SetBudget input, User user) async {
    Group group = await groupOf(user, input.groupId);
    String key = input.month;
    num? budget = input.budget.value;
    int? cents = budget == null ? null : MoneyUtil.toCents(budget);
    int? effective = await budgets.setForMonth(group, key, cents);
    // The same shape as PUT /groups/{id}/budget. After a clear, this is the
    // carried-forward budget, or null when there is none.
    return AppTool.json(<String, dynamic>{
      'month': key,
      'currency': group.currency,
      'monthlyBudgetCents': effective,
    });
  }
}

@Inject()
class GetDefaultWalletTool extends AppTool<GroupRef> {
  GetDefaultWalletTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'get_default_wallet';

  @override
  String get description =>
      'The wallet that new expenses in this group are paid from, for the MCP '
      'user. accountId is null when there is none.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int? id = await accounts.defaultAccountId(user, group);
    return AppTool.json(<String, dynamic>{'accountId': id});
  }
}

@Inject()
class SetDefaultWalletTool extends AppTool<SetDefaultAccount> {
  SetDefaultWalletTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'set_default_wallet';

  @override
  String get description =>
      'Set (or clear, with accountId=null) the wallet that new expenses in '
      'this group are paid from, for the MCP user.';

  @override
  DtoSchema<SetDefaultAccount> get dto => SetDefaultAccount.schema;

  @override
  Future<McpToolResult> run(SetDefaultAccount input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int? id = input.accountId.value;
    await accounts.setDefaultAccountId(user, group, id);
    return AppTool.json(<String, dynamic>{'accountId': id});
  }
}
