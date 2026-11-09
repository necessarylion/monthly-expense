import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class UserRepository {
  static User _q() => User();

  Future<User?> findById(int id) => _q().where('id', id).getFirst();

  Future<User?> findByFirebaseUid(String uid) {
    return _q().where('firebase_uid', uid).getFirst();
  }

  Future<User?> findByEmail(String email) =>
      _q().where('email', email).getFirst();

  Future<User> create({
    required String firebaseUid,
    required String email,
    required String? displayName,
    required String? photoUrl,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'firebase_uid': firebaseUid,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names, like `{'email': email}`.
  Future<User> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
