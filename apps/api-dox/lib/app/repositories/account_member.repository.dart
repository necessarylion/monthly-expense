import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/row.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class AccountMemberRepository {
  static AccountMember _q() => AccountMember();

  Future<AccountMember?> findJoined(int accountId, int userId) {
    return _q()
        .where('account_id', accountId)
        .where('user_id', userId)
        .whereNotNull('joined_at')
        .getFirst();
  }

  Future<AccountMember?> findByAccountAndId(int accountId, int id) {
    return _q().where('account_id', accountId).where('id', id).getFirst();
  }

  Future<AccountMember?> findByAccountAndEmail(int accountId, String email) {
    return _q().where('account_id', accountId).where('email', email).getFirst();
  }

  Future<List<AccountMember>> listByAccount(int accountId) {
    return _q().where('account_id', accountId).orderBy('id').get();
  }

  /// Which of these accounts have at least one member or pending invite.
  Future<Set<int>> accountIdsWithMembers(List<int> accountIds) async {
    if (accountIds.isEmpty) return <int>{};
    List<Map<String, dynamic>> rows = await QueryBuilder.table(
      'account_members',
    ).select('account_id').distinct().whereIn('account_id', accountIds).get();
    return <int>{
      for (Map<String, dynamic> row in rows)
        DbRow.toInt(row['account_id']) ?? 0,
    };
  }

  Future<List<AccountMember>> pendingByEmail(String email) {
    return _q().whereNull('user_id').where('email', email).get();
  }

  Future<AccountMember> create({
    required int accountId,
    required int? userId,
    required String email,
    required int? invitedByUserId,
    required String? joinedAt,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'account_id': accountId,
      'user_id': userId,
      'email': email,
      'invited_by_user_id': invitedByUserId,
      'joined_at': joinedAt,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names.
  Future<void> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
