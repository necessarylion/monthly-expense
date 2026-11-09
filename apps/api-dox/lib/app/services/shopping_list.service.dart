import 'package:api_dox/app/dtos/shopping_item/shopping_item.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/shopping_item.repository.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// A shared shopping list per group. Every member sees and ticks the same
/// items.
@Inject()
class ShoppingListService {
  ShoppingListService(this.items);

  final ShoppingItemRepository items;

  /// Still to buy (oldest first), then bought (latest first).
  Future<List<ShoppingItem>> list(Group group) async {
    List<ShoppingItem> todo = <ShoppingItem>[];
    List<ShoppingItem> done = <ShoppingItem>[];
    for (ShoppingItem item in await items.listByGroup(group.id!)) {
      (item.doneAt == null ? todo : done).add(item);
    }
    done.sort(_latestDoneFirst);
    return <ShoppingItem>[...todo, ...done];
  }

  static int _latestDoneFirst(ShoppingItem a, ShoppingItem b) {
    int byTime = (b.doneAt ?? '').compareTo(a.doneAt ?? '');
    return byTime != 0 ? byTime : b.id! - a.id!;
  }

  Future<ShoppingItem> assertInGroup(Group group, int? id) async {
    ShoppingItem? item = id == null ? null : await items.findById(id);
    if (item == null || item.groupId != group.id) {
      throw HttpError.notFound('Item not found');
    }
    return item;
  }

  Future<ShoppingItem> create(Group group, User user, String name) {
    return items.create(group.id!, name, user.id!);
  }

  Future<ShoppingItem> update(ShoppingItem item, UpdateShoppingItem fields) {
    Map<String, dynamic> changes = <String, dynamic>{
      if (fields.name != null) 'name': fields.name,
      // Ticking an already-bought item keeps its first time.
      if (fields.done != null)
        'done_at': fields.done! ? (item.doneAt ?? DateUtil.nowSql()) : null,
    };
    if (changes.isEmpty) return Future<ShoppingItem>.value(item);
    return items.update(item.id!, changes);
  }

  Future<void> delete(ShoppingItem item) => items.delete(item.id!);

  Future<int> clearDone(Group group) => items.deleteDone(group.id!);
}
