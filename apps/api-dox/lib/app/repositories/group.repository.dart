import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class GroupRepository {
  static Group _q() => Group();

  Future<Group?> findById(int id) async {
    return _q().where('id', id).getFirst();
  }

  Future<Group> create({
    required String name,
    required String currency,
    required int? createdByUserId,
    String? kind,
    String? tripStart,
    int? tripDays,
    bool? splitEnabled,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'name': name,
      'currency': currency,
      'created_by_user_id': createdByUserId,
      'kind': kind,
      'trip_start': tripStart,
      'trip_days': tripDays,
      'split_enabled': splitEnabled,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names.
  Future<Group> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  /// Cascades to members, categories, expenses and budgets.
  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
