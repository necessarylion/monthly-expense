import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class PasskeyRepository {
  static Passkey _q() => Passkey();

  Future<Passkey?> findByCredentialId(String credentialId) {
    return _q().where('credential_id', credentialId).getFirst();
  }

  /// Newest first.
  Future<List<Passkey>> listByUser(int userId) {
    return _q()
        .where('user_id', userId)
        .orderBy('created_at', 'desc')
        .orderBy('id', 'desc')
        .get();
  }

  Future<int> countByUser(int userId) {
    return _q().where('user_id', userId).count();
  }

  Future<void> create({
    required int userId,
    required String credentialId,
    required String publicKey,
    required int signCount,
    required String name,
  }) async {
    String now = DateUtil.nowSql();
    await _q().create(<String, dynamic>{
      'user_id': userId,
      'credential_id': credentialId,
      'public_key': publicKey,
      'sign_count': signCount,
      'name': name,
      'last_used_at': null,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> markUsed(int id, int signCount) async {
    String now = DateUtil.nowSql();
    await _q().where('id', id).update(<String, dynamic>{
      'sign_count': signCount,
      'last_used_at': now,
      'updated_at': now,
    });
  }

  /// True when the row was there (and belonged to [userId]).
  Future<bool> deleteForUser(int userId, int id) async {
    int count = await _q().where('id', id).where('user_id', userId).delete();
    return count > 0;
  }
}
