import 'package:api_dox/app/models/user/user.model.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
///
/// `GET /me`. Leaves out the MCP token and the timestamps.
class UserSerializer extends Serializer<User> {
  UserSerializer(super.data);

  @override
  Map<String, dynamic> convert(User m) {
    return <String, dynamic>{
      'id': m.id,
      'firebaseUid': m.firebaseUid,
      'email': m.email,
      'displayName': m.displayName,
      'photoUrl': m.photoUrl,
    };
  }
}
