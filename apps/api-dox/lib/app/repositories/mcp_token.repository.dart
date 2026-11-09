import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class McpTokenRepository {
  static McpToken _q() => McpToken();

  Future<McpToken?> findByHash(String tokenHash) {
    return _q().where('token_hash', tokenHash).getFirst();
  }

  /// Newest first.
  Future<List<McpToken>> listByUser(int userId) {
    return _q()
        .where('user_id', userId)
        .orderBy('created_at', 'desc')
        .orderBy('id', 'desc')
        .get();
  }

  Future<int> countByUser(int userId) {
    return _q().where('user_id', userId).count();
  }

  Future<void> create(int userId, String name, String tokenHash) async {
    String now = DateUtil.nowSql();
    await _q().create(<String, dynamic>{
      'user_id': userId,
      'name': name,
      'token_hash': tokenHash,
      'last_used_at': null,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> touch(int id) async {
    String now = DateUtil.nowSql();
    await _q().where('id', id).update(<String, dynamic>{
      'last_used_at': now,
      'updated_at': now,
    });
  }

  /// True when the row was there (and belonged to [userId]).
  Future<bool> deleteForUser(int userId, int id) async {
    int count = await _q().where('id', id).where('user_id', userId).delete();
    return count > 0;
  }

  Future<void> deleteAllForUser(int userId) async {
    await _q().where('user_id', userId).delete();
  }
}
