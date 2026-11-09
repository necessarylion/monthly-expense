import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class ShoppingItemSerializer extends Serializer<ShoppingItem> {
  ShoppingItemSerializer(super.data);

  @override
  Map<String, dynamic> convert(ShoppingItem m) {
    return <String, dynamic>{
      'id': m.id,
      'groupId': m.groupId,
      'name': m.name,
      'done': m.doneAt != null,
      'doneAt': DateUtil.toIso(m.doneAt),
      'createdByUserId': m.createdByUserId,
      'createdAt': DateUtil.toIso(m.createdAtText),
    };
  }
}
