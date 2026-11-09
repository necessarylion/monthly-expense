import 'package:api_dox/app/models/group/group.model.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class GroupSerializer extends Serializer<Group> {
  GroupSerializer(super.data);

  @override
  Map<String, dynamic> convert(Group m) {
    return <String, dynamic>{
      'id': m.id,
      'name': m.name,
      'currency': m.currency,
      'createdByUserId': m.createdByUserId,
    };
  }
}
