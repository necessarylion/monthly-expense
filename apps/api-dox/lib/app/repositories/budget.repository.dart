import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class BudgetRepository {
  static GroupMonthlyBudget _q() => GroupMonthlyBudget();

  /// The latest budget row at or before [monthKey] (carry-forward).
  Future<GroupMonthlyBudget?> latestAtOrBefore(int groupId, String monthKey) {
    return _q()
        .where('group_id', groupId)
        .where('month_key', '<=', monthKey)
        .orderBy('month_key', 'desc')
        .getFirst();
  }

  Future<GroupMonthlyBudget?> findByMonth(int groupId, String monthKey) {
    return _q()
        .where('group_id', groupId)
        .where('month_key', monthKey)
        .getFirst();
  }

  Future<void> create(int groupId, String monthKey, int budgetCents) async {
    String now = DateUtil.nowSql();
    await _q().create(<String, dynamic>{
      'group_id': groupId,
      'month_key': monthKey,
      'budget_cents': budgetCents,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> updateCents(int id, int budgetCents) async {
    await _q().where('id', id).update(<String, dynamic>{
      'budget_cents': budgetCents,
      'updated_at': DateUtil.nowSql(),
    });
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
