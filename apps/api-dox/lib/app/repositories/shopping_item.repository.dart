import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class ShoppingItemRepository {
  static ShoppingItem _q() => ShoppingItem();

  Future<ShoppingItem?> findById(int id) async {
    return _q().where('id', id).getFirst();
  }

  /// Oldest first; the service puts bought items after the rest.
  Future<List<ShoppingItem>> listByGroup(int groupId) async {
    return _q()
        .where('group_id', groupId)
        .orderBy('created_at')
        .orderBy('id')
        .get();
  }

  Future<ShoppingItem> create(int groupId, String name, int userId) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'group_id': groupId,
      'name': name,
      'done_at': null,
      'created_by_user_id': userId,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names, like `{'done_at': null}`.
  Future<ShoppingItem> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }

  /// Removes the bought items. Returns how many went.
  Future<int> deleteDone(int groupId) {
    return _q().where('group_id', groupId).whereNotNull('done_at').delete();
  }
}
