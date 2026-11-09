import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/row.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class GroupMemberRepository {
  static GroupMember _q() => GroupMember();

  /// This user's row in this group, joined or not.
  Future<GroupMember?> findByGroupAndUser(int groupId, int userId) {
    return _q().where('group_id', groupId).where('user_id', userId).getFirst();
  }

  Future<GroupMember?> findJoined(int groupId, int userId) {
    return _q()
        .where('group_id', groupId)
        .where('user_id', userId)
        .whereNotNull('joined_at')
        .getFirst();
  }

  Future<GroupMember?> findByGroupAndId(int groupId, int id) {
    return _q().where('group_id', groupId).where('id', id).getFirst();
  }

  Future<GroupMember?> findByGroupAndEmail(int groupId, String email) {
    return _q().where('group_id', groupId).where('email', email).getFirst();
  }

  Future<GroupMember?> firstJoinedForUser(int userId) {
    return _q()
        .where('user_id', userId)
        .whereNotNull('joined_at')
        .orderBy('id')
        .getFirst();
  }

  Future<bool> hasJoinedMembers(int groupId) {
    return _q().where('group_id', groupId).whereNotNull('joined_at').hasRows();
  }

  /// Groups the user has joined, oldest membership first.
  Future<List<Group>> joinedGroupsForUser(int userId) async {
    return Group()
        .select('groups.*')
        .join('group_members', 'group_members.group_id', 'groups.id')
        .where('group_members.user_id', userId)
        .whereNotNull('group_members.joined_at')
        .orderBy('group_members.joined_at')
        .orderBy('group_members.id')
        .get();
  }

  Future<List<GroupMember>> listByGroup(int groupId) {
    return _q().where('group_id', groupId).orderBy('id').get();
  }

  Future<List<GroupMember>> pendingByEmail(String email) {
    return _q().whereNull('user_id').where('email', email).get();
  }

  /// Account ids that any of the user's memberships use as their pay-from
  /// default.
  Future<Set<int>> defaultAccountIdsForUser(int userId) async {
    List<Map<String, dynamic>> rows = await QueryBuilder.table('group_members')
        .select('default_account_id')
        .where('user_id', userId)
        .whereNotNull('default_account_id')
        .get();
    return <int>{
      for (Map<String, dynamic> row in rows)
        if (DbRow.toInt(row['default_account_id']) != null)
          DbRow.toInt(row['default_account_id'])!,
    };
  }

  Future<void> setDefaultAccountForAllMemberships(
    int userId,
    int accountId,
  ) async {
    await _q().where('user_id', userId).update(<String, dynamic>{
      'default_account_id': accountId,
      'updated_at': DateUtil.nowSql(),
    });
  }

  Future<void> clearDefaultAccount(int userId, int accountId) async {
    await _q()
        .where('user_id', userId)
        .where('default_account_id', accountId)
        .update(<String, dynamic>{
          'default_account_id': null,
          'updated_at': DateUtil.nowSql(),
        });
  }

  Future<GroupMember> create({
    required int groupId,
    required int? userId,
    required String email,
    required int? invitedByUserId,
    required String? joinedAt,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'group_id': groupId,
      'user_id': userId,
      'email': email,
      'invited_by_user_id': invitedByUserId,
      'joined_at': joinedAt,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names.
  Future<GroupMember> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await _q().where('id', id).getFirst())!;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
