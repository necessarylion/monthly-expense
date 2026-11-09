import 'package:api_dox/app/models/account/account.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class AccountSerializer extends Serializer<Account> {
  AccountSerializer(super.data);

  @override
  Map<String, dynamic> convert(Account m) {
    return <String, dynamic>{
      'id': m.id,
      'userId': m.userId,
      'name': m.name,
      'currency': m.currency,
      'color': m.color,
      'includeInTotal': m.includeInTotal,
      'createdAt': DateUtil.toIso(m.createdAtText),
      'updatedAt': DateUtil.toIso(m.updatedAtText),
    };
  }
}
