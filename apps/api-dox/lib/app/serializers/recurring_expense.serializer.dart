import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields.
class RecurringExpenseSerializer extends Serializer<RecurringExpense> {
  RecurringExpenseSerializer(super.data);

  @override
  Map<String, dynamic> convert(RecurringExpense m) {
    return <String, dynamic>{
      'id': m.id,
      'groupId': m.groupId,
      'createdByUserId': m.createdByUserId,
      'categoryId': m.categoryId,
      'accountId': m.accountId,
      'amountCents': m.amountCents,
      'note': m.note,
      'dayOfMonth': m.dayOfMonth,
      'nextOn': m.nextOn,
      'createdAt': DateUtil.toIso(m.createdAtText),
    };
  }
}
