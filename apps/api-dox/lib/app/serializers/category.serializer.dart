import 'package:api_dox/app/models/category/category.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class CategorySerializer extends Serializer<Category> {
  CategorySerializer(super.data);

  @override
  Map<String, dynamic> convert(Category m) {
    return <String, dynamic>{
      'id': m.id,
      'groupId': m.groupId,
      'name': m.name,
      'slug': m.slug,
      'iconKey': m.iconKey,
      'color': m.color,
      'budgetCents': m.budgetCents,
      'createdAt': DateUtil.toIso(m.createdAtText),
    };
  }
}
