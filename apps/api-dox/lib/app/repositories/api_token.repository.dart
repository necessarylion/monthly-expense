import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class ApiTokenRepository {
  static ApiToken _q() => ApiToken();

  Future<ApiToken?> findByHash(String tokenHash) {
    return _q().where('token_hash', tokenHash).getFirst();
  }

  Future<void> create({
    required int userId,
    required String tokenHash,
    required String name,
    required bool secondFactor,
    required String expiresAt,
  }) async {
    String now = DateUtil.nowSql();
    await _q().create(<String, dynamic>{
      'user_id': userId,
      'token_hash': tokenHash,
      'name': name,
      'second_factor': secondFactor,
      'last_used_at': now,
      'expires_at': expiresAt,
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

  /// Ends the token at [expiresAt] (a refresh leaves the old one a moment).
  Future<void> expireAt(int id, String expiresAt) async {
    await _q().where('id', id).update(<String, dynamic>{
      'expires_at': expiresAt,
      'updated_at': DateUtil.nowSql(),
    });
  }

  Future<void> markSecondFactor(int id) async {
    await _q().where('id', id).update(<String, dynamic>{
      'second_factor': true,
      'updated_at': DateUtil.nowSql(),
    });
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }

  /// Timestamps are `YYYY-MM-DD HH:MM:SS` text, so text order is time order.
  Future<void> deleteExpiredForUser(int userId, String now) async {
    await _q().where('user_id', userId).where('expires_at', '<', now).delete();
  }
}
