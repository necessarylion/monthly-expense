import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'group.dto.g.dart';

/// Body of POST /groups, and the create_group tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateGroup {
  @Trim()
  @Length(min: 1, max: 80)
  @Describe('Group name, e.g. "Family".')
  final String name;

  /// ISO 4217 code. Default: the group default.
  @Trim()
  @Uppercase()
  @Regex(r'[A-Z]{3}', message: 'Expected a 3-letter currency code')
  @Describe('$currencyHint Defaults to THB.')
  final String? currency;

  @In(<Object>['monthly', 'trip'])
  @Describe(groupKindHint)
  final String? kind;

  @DateFormatted('Y-m-d')
  @Describe('Trip only: the first day, YYYY-MM-DD. Defaults to today.')
  final String? tripStart;

  @Min(1)
  @Max(366)
  @Describe('Trip only: how many days the trip lasts.')
  final int? tripDays;

  const CreateGroup({
    required this.name,
    this.currency,
    this.kind,
    this.tripStart,
    this.tripDays,
  });

  static const DtoSchema<CreateGroup> schema = $CreateGroupDto;
}

/// Body of PATCH /groups/{id}, and the update_group tool. A missing key is
/// not changed.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateGroup {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Trim()
  @Length(min: 1, max: 80)
  @Describe('New group name.')
  final String? name;

  @Trim()
  @Uppercase()
  @Regex(r'[A-Z]{3}', message: 'Expected a 3-letter currency code')
  @Describe('New currency. $currencyHint')
  final String? currency;

  @Describe(
    'Turn on to split costs: each expense has a payer, and the members '
    'settle up each month.',
  )
  final bool? splitEnabled;

  @In(<Object>['monthly', 'trip'])
  @Describe(groupKindHint)
  final String? kind;

  @DateFormatted('Y-m-d')
  @Describe('Trip only: the first day, YYYY-MM-DD. Defaults to today.')
  final String? tripStart;

  @Min(1)
  @Max(366)
  @Describe('Trip only: how many days the trip lasts.')
  final int? tripDays;

  const UpdateGroup({
    this.groupId,
    this.name,
    this.currency,
    this.splitEnabled,
    this.kind,
    this.tripStart,
    this.tripDays,
  });

  static const DtoSchema<UpdateGroup> schema = $UpdateGroupDto;
}

/// Body of PUT /groups/{id}/budget, and the set_budget tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class SetBudget {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  /// `YYYY-MM`
  @Trim()
  @DateFormatted('Y-m')
  @Describe('Month in YYYY-MM format.')
  final String month;

  /// Must be sent. `null` clears this month's budget, so the one before
  /// carries forward again.
  @Min(0)
  @Max(1000000000)
  @Describe(
    'Monthly budget in dollars. Pass null to clear the budget of this '
    'month, so the one before carries forward again.',
  )
  final Maybe<num?> budget;

  const SetBudget({
    this.groupId,
    required this.month,
    this.budget = const Maybe<num?>.missing(),
  });

  void validate(DtoErrors errors) {
    if (!budget.isPresent) errors.add('budget', 'The budget is required');
  }

  static const DtoSchema<SetBudget> schema = $SetBudgetDto;
}

/// Body of POST /groups/{id}/invitations and /accounts/{id}/members, and
/// the two invite tools.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class Invite {
  /// MCP only: invite_group_member.
  @Positive()
  @Describe('Group ID, for invite_group_member (see list_groups).')
  final int? groupId;

  /// MCP only: invite_wallet_member.
  @Positive()
  @Describe('Wallet ID, for invite_wallet_member (see list_wallets).')
  final int? accountId;

  @Trim()
  @Lowercase()
  @Email()
  @Describe(emailHint)
  final String email;

  const Invite({this.groupId, this.accountId, required this.email});

  static const DtoSchema<Invite> schema = $InviteDto;
}

// Ids for the MCP tools that have no body. HTTP gets them from the URL.

/// No arguments.
@Dto(keyCase: KeyCase.field)
class NoInput {
  const NoInput();

  static const DtoSchema<NoInput> schema = $NoInputDto;
}

@Dto(keyCase: KeyCase.field)
class GroupRef {
  @Positive()
  @Describe(groupIdHint)
  final int groupId;

  const GroupRef({required this.groupId});

  static const DtoSchema<GroupRef> schema = $GroupRefDto;
}

/// A group and one item in it: a category, an expense or a shopping item.
@Dto(keyCase: KeyCase.field)
class GroupItemRef {
  @Positive()
  @Describe(groupIdHint)
  final int groupId;

  @Positive()
  @Describe(itemIdHint)
  final int id;

  const GroupItemRef({required this.groupId, required this.id});

  static const DtoSchema<GroupItemRef> schema = $GroupItemRefDto;
}

@Dto(keyCase: KeyCase.field)
class GroupMemberRef {
  @Positive()
  @Describe(groupIdHint)
  final int groupId;

  @Positive()
  @Describe('Member ID (see list_group_members).')
  final int memberId;

  const GroupMemberRef({required this.groupId, required this.memberId});

  static const DtoSchema<GroupMemberRef> schema = $GroupMemberRefDto;
}
