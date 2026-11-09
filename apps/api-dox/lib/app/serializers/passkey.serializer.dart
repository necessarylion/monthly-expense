import 'package:api_dox/app/models/passkey/passkey.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// One passkey on the Me page. The key itself never leaves.
class PasskeySerializer extends Serializer<Passkey> {
  PasskeySerializer(super.data);

  @override
  Map<String, dynamic> convert(Passkey m) {
    return <String, dynamic>{
      'id': m.id,
      'name': m.name,
      'lastUsedAt': DateUtil.toIso(m.lastUsedAt),
      'createdAt': DateUtil.toIso(m.createdAtText),
    };
  }
}
