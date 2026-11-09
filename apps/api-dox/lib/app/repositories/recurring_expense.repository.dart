import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

@Inject()
class RecurringExpenseRepository {
  static RecurringExpense _q() => RecurringExpense();

  Future<RecurringExpense?> findById(int id) => _q().where('id', id).getFirst();

  Future<List<RecurringExpense>> listByGroup(int groupId) {
    return _q()
        .where('group_id', groupId)
        .orderBy('day_of_month')
        .orderBy('id')
        .get();
  }

  Future<int> countByGroup(int groupId) {
    return _q().where('group_id', groupId).count();
  }

  /// Rows that should have added an expense by [today].
  Future<List<RecurringExpense>> listDue(String today) {
    return _q().where('next_on', '<=', today).orderBy('id').get();
  }

  Future<RecurringExpense> create(Map<String, dynamic> values) {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      ...values,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// Moves `next_on` from [from] to [to]. Returns false when another run
  /// moved it first, so only one run adds the expense.
  Future<bool> claim(int id, String from, String to) async {
    int changed = await _q().where('id', id).where('next_on', from).update(
      <String, dynamic>{'next_on': to, 'updated_at': DateUtil.nowSql()},
    );
    return changed == 1;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
