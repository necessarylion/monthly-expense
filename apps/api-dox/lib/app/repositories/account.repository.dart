import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class AccountRepository {
  static Account _q() => Account();

  Future<Account?> findById(int id) async {
    return _q().where('id', id).getFirst();
  }

  /// Accounts the user owns, plus accounts shared with them.
  Future<List<Account>> listByUser(int userId) async {
    return _q()
        .whereGroup((QueryBuilder<Account> q) {
          q.where('user_id', userId).orWhereIn('id', sharedIds(userId));
        })
        .orderBy('name')
        .get();
  }

  Future<Account> create({
    required int userId,
    required String name,
    required String currency,
    required String color,
    required bool includeInTotal,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'user_id': userId,
      'name': name,
      'currency': currency,
      'color': color,
      'include_in_total': includeInTotal,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names.
  Future<Account> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  /// Cascades to the account's entries.
  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }

  /// Sub query: ids of accounts the user has joined as a member.
  static QueryBuilder<Map<String, dynamic>> sharedIds(int userId) {
    return QueryBuilder.table('account_members')
        .select('account_id')
        .where('user_id', userId)
        .whereNotNull('joined_at');
  }
}
