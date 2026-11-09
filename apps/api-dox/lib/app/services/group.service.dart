import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/category.repository.dart';
import 'package:api_dox/app/repositories/group.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/constants/live.dart';
import 'package:api_dox/constants/categories.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class GroupService {
  GroupService(
    this.groups,
    this.members,
    this.categories,
    this.users,
    this.live,
  );

  final GroupRepository groups;
  final GroupMemberRepository members;
  final CategoryRepository categories;
  final UserRepository users;
  final LiveService live;

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// A new group with the creator as its first member and the default
  /// categories.
  Future<Group> createForUser(
    User user, {
    required String name,
    String? currency,
    String? kind,
    String? tripStart,
    int? tripDays,
  }) async {
    bool trip = kind == groupKindTrip;
    Group group = await groups.create(
      name: name.trim(),
      currency: (currency ?? defaultGroupCurrency).toUpperCase(),
      createdByUserId: user.id,
      kind: trip ? groupKindTrip : null,
      tripStart: trip ? (tripStart ?? DateUtil.today()) : null,
      tripDays: trip ? tripDays : null,
      // Friends on a trip usually split the bills.
      splitEnabled: trip ? true : null,
    );
    await members.create(
      groupId: group.id!,
      userId: user.id,
      email: normalizeEmail(user.email),
      invitedByUserId: user.id,
      joinedAt: DateUtil.nowSql(),
    );
    await categories.createMany(<NewCategory>[
      for (DefaultCategory category in defaultCategories)
        NewCategory(
          groupId: group.id!,
          name: category.name,
          slug: category.slug,
          iconKey: category.iconKey,
          color: category.color,
        ),
    ]);
    return group;
  }

  Future<Group> update(
    Group group, {
    String? name,
    String? currency,
    bool? splitEnabled,
    String? kind,
    String? tripStart,
    int? tripDays,
  }) async {
    Map<String, dynamic> changes = <String, dynamic>{
      'trip_start': ?tripStart,
      'trip_days': ?tripDays,
      if (kind != null) 'kind': kind == groupKindTrip ? groupKindTrip : null,
      if (name != null && name.isNotEmpty) 'name': name,
      if (currency != null && currency.isNotEmpty) 'currency': currency,
      'split_enabled': ?splitEnabled,
    };
    if (kind == groupKindTrip && group.tripStart == null && tripStart == null) {
      changes['trip_start'] = DateUtil.today();
    }
    if (changes.isEmpty) return group;
    Group updated = await groups.update(group.id!, changes);
    await live.groupChanged(group.id!, liveTopicGroup);
    return updated;
  }

  /// True when the user has joined at least one group.
  Future<bool> hasGroup(User user) async {
    return await members.firstJoinedForUser(user.id!) != null;
  }

  /// Called on every sign-in, so a user is never without a group.
  Future<Group> ensurePersonalGroup(User user) async {
    GroupMember? existing = await members.firstJoinedForUser(user.id!);
    if (existing != null) {
      Group? group = await groups.findById(existing.groupId);
      if (group != null) return group;
    }
    String? displayName = user.displayName?.trim();
    String firstName = (displayName == null || displayName.isEmpty)
        ? ''
        : displayName.split(RegExp(r'\s+')).first;
    return createForUser(
      user,
      name: firstName.isNotEmpty ? "$firstName's Group" : 'Personal',
    );
  }

  /// Attach every pending invite for this user's email.
  Future<int> claimPendingInvitations(User user) async {
    String email = normalizeEmail(user.email);
    if (email.isEmpty) return 0;
    List<GroupMember> pending = await members.pendingByEmail(email);
    for (GroupMember row in pending) {
      await members.update(row.id!, <String, dynamic>{
        'user_id': user.id,
        'joined_at': DateUtil.nowSql(),
      });
    }
    return pending.length;
  }

  Future<List<Group>> listForUser(User user) {
    return members.joinedGroupsForUser(user.id!);
  }

  /// 404, not 403, so outsiders do not learn that the group exists.
  Future<Group> assertMembership(User user, int? groupId) async {
    if (groupId == null) throw HttpError.notFound('Group not found');
    GroupMember? member = await members.findJoined(groupId, user.id!);
    Group? group = member == null ? null : await groups.findById(groupId);
    if (group == null) throw HttpError.notFound('Group not found');
    return group;
  }

  Future<List<GroupMember>> listMembers(Group group) {
    return members.listByGroup(group.id!);
  }

  Future<GroupMember> invite(Group group, User inviter, String email) async {
    String normalized = normalizeEmail(email);
    if (!normalized.endsWith(inviteEmailDomain)) {
      throw HttpError.unprocessable(
        'Only $inviteEmailDomain addresses can be invited',
      );
    }
    GroupMember? existing = await members.findByGroupAndEmail(
      group.id!,
      normalized,
    );
    if (existing != null) return existing;

    User? user = await users.findByEmail(normalized);
    GroupMember member = await members.create(
      groupId: group.id!,
      userId: user?.id,
      email: normalized,
      invitedByUserId: inviter.id,
      joinedAt: user == null ? null : DateUtil.nowSql(),
    );
    // the new member is told too: the group shows up in their list
    await live.groupChanged(group.id!, liveTopicGroup);
    return member;
  }

  /// Removes a member. The group is deleted when no joined member is left.
  Future<void> removeMember(Group group, int? memberId) async {
    GroupMember? member = memberId == null
        ? null
        : await members.findByGroupAndId(group.id!, memberId);
    if (member == null) throw HttpError.notFound('Member not found');
    // found first: the removed member must hear it too
    Set<int> users = await live.usersOfGroup(group.id!);
    await members.delete(member.id!);
    if (!await members.hasJoinedMembers(group.id!)) {
      await groups.delete(group.id!);
    }
    await live.notify(users, liveTopicGroup, groupId: group.id!);
  }

  Future<void> leave(Group group, User user) async {
    GroupMember? me = await members.findByGroupAndUser(group.id!, user.id!);
    if (me == null) throw HttpError.notFound('Not a member');
    await removeMember(group, me.id);
  }
}
