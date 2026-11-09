import 'package:api_dox/app/models/account_entry/account_entry.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class AccountEntrySerializer extends Serializer<AccountEntry> {
  AccountEntrySerializer(super.data);

  @override
  Map<String, dynamic> convert(AccountEntry m) {
    return <String, dynamic>{
      'id': m.id,
      'accountId': m.accountId,
      'expenseId': m.expenseId,
      'amountCents': m.amountCents,
      'occurredOn': m.occurredOn,
      'note': m.note,
      'createdAt': DateUtil.toIso(m.createdAtText),
      'updatedAt': DateUtil.toIso(m.updatedAtText),
    };
  }
}
