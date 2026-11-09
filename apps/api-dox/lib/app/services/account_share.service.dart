import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account_member.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/constants/live.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// One row of the "shared with" list. The owner row has `id: null`.
class AccountMemberView {
  final int? id;
  final int accountId;
  final int? userId;
  final String email;
  final bool owner;
  final bool pending;

  const AccountMemberView({
    required this.id,
    required this.accountId,
    required this.userId,
    required this.email,
    required this.owner,
    required this.pending,
  });

  factory AccountMemberView.of(AccountMember member) {
    return AccountMemberView(
      id: member.id,
      accountId: member.accountId,
      userId: member.userId,
      email: member.email,
      owner: false,
      pending: member.userId == null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'accountId': accountId,
      'userId': userId,
      'email': email,
      'owner': owner,
      'pending': pending,
    };
  }
}

/// Sharing a wallet works like inviting to a group: invite a Gmail
/// address, and the person joins on their next sign-in. Every member can do
/// everything the owner can, including sharing further. Only the owner row
/// cannot be removed, so the wallet always has an owner.
@Inject()
class AccountShareService {
  AccountShareService(this.members, this.users, this.live);

  final AccountMemberRepository members;
  final UserRepository users;
  final LiveService live;

  /// The owner first, then members in invite order.
  Future<List<AccountMemberView>> listMembers(Account account) async {
    List<AccountMemberView> result = <AccountMemberView>[];
    User? owner = await users.findById(account.userId);
    if (owner != null) {
      result.add(
        AccountMemberView(
          id: null,
          accountId: account.id!,
          userId: owner.id,
          email: owner.email,
          owner: true,
          pending: false,
        ),
      );
    }
    for (AccountMember member in await members.listByAccount(account.id!)) {
      result.add(AccountMemberView.of(member));
    }
    return result;
  }

  Future<AccountMemberView> invite(
    Account account,
    User inviter,
    String email,
  ) async {
    String normalized = GroupService.normalizeEmail(email);
    if (!normalized.endsWith(inviteEmailDomain)) {
      throw HttpError.unprocessable(
        'Only $inviteEmailDomain addresses can be invited',
      );
    }
    User? owner = await users.findById(account.userId);
    if (owner != null &&
        GroupService.normalizeEmail(owner.email) == normalized) {
      throw HttpError.unprocessable('This person already owns the wallet');
    }
    AccountMember? existing = await members.findByAccountAndEmail(
      account.id!,
      normalized,
    );
    if (existing != null) return AccountMemberView.of(existing);

    User? user = await users.findByEmail(normalized);
    AccountMember member = await members.create(
      accountId: account.id!,
      userId: user?.id,
      email: normalized,
      invitedByUserId: inviter.id,
      joinedAt: user == null ? null : DateUtil.nowSql(),
    );
    await live.accountChanged(account.id!);
    return AccountMemberView.of(member);
  }

  /// Removing yourself is how a member leaves.
  Future<void> removeMember(Account account, int? memberId) async {
    AccountMember? member = memberId == null
        ? null
        : await members.findByAccountAndId(account.id!, memberId);
    if (member == null) throw HttpError.notFound('Member not found');
    Set<int> users = await live.usersOfAccount(account.id!);
    await members.delete(member.id!);
    await live.notify(users, liveTopicAccounts);
  }

  /// Attach every pending wallet invite for this user's email. Runs on
  /// sign-in.
  Future<void> claimPendingInvitations(User user) async {
    String email = GroupService.normalizeEmail(user.email);
    if (email.isEmpty) return;
    for (AccountMember row in await members.pendingByEmail(email)) {
      await members.update(row.id!, <String, dynamic>{
        'user_id': user.id,
        'joined_at': DateUtil.nowSql(),
      });
    }
  }
}
