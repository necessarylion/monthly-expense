import 'package:api_dox/app/serializers/category.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
///
/// An expense with its category inside (`category` is `null` when it has
/// none).
class ExpenseSerializer extends Serializer<ExpenseWithCategory> {
  ExpenseSerializer(super.data);

  @override
  Map<String, dynamic> convert(ExpenseWithCategory m) {
    Expense expense = m.expense;
    return <String, dynamic>{
      'id': expense.id,
      'groupId': expense.groupId,
      'createdByUserId': expense.createdByUserId,
      'paidByUserId': expense.payerId,
      'categoryId': expense.categoryId,
      'amountCents': expense.amountCents,
      'occurredOn': expense.occurredOn,
      'note': expense.note,
      'createdAt': DateUtil.toIso(expense.createdAtText),
      'updatedAt': DateUtil.toIso(expense.updatedAtText),
      'category': CategorySerializer(m.category).toJson(),
    };
  }
}
