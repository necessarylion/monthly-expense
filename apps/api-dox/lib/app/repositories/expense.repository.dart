import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/row.dart';
import 'package:dox_orm/dox_orm.dart';

/// An expense the group logs again and again (same category, amount, note).
class FrequentExpense {
  final int? categoryId;
  final int amountCents;
  final String? note;
  final int uses;
  final String lastOn;

  const FrequentExpense({
    required this.categoryId,
    required this.amountCents,
    required this.note,
    required this.uses,
    required this.lastOn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'amountCents': amountCents,
      'note': note,
      'uses': uses,
      'lastOn': lastOn,
    };
  }
}

@Inject()
class ExpenseRepository {
  static Expense _q() => Expense();

  Future<Expense?> findById(int id) async {
    return _q().where('id', id).getFirst();
  }

  /// Expenses dated from [start] to [end] (both included), newest first.
  Future<List<Expense>> listInRange(int groupId, String start, String end) {
    return _q()
        .where('group_id', groupId)
        .where('occurred_on', '>=', start)
        .where('occurred_on', '<=', end)
        .orderBy('occurred_on', 'desc')
        .orderBy('id', 'desc')
        .get();
  }

  /// Expenses logged again and again since [since]: same category, amount
  /// and note, at least [minUses] times. Most used first, then most recent.
  Future<List<FrequentExpense>> frequent(
    int groupId,
    String since,
    int minUses,
    int limit,
  ) async {
    List<Map<String, dynamic>> rows = await QueryBuilder.table('expenses')
        .selectRaw(
          'category_id, amount_cents, note, count(id) as uses, '
          'max(occurred_on) as last_on',
        )
        .where('group_id', groupId)
        .where('occurred_on', '>=', since)
        .groupBy(<String>['category_id', 'amount_cents', 'note'])
        .havingRaw('count(id) >= @min_uses', <String, dynamic>{
          'min_uses': minUses,
        })
        .orderByRaw('count(id) desc, max(occurred_on) desc')
        .limit(limit)
        .get();
    return <FrequentExpense>[
      for (Map<String, dynamic> row in rows)
        FrequentExpense(
          categoryId: DbRow.toInt(row['category_id']),
          amountCents: DbRow.toInt(row['amount_cents']) ?? 0,
          note: row['note']?.toString(),
          uses: DbRow.toInt(row['uses']) ?? 0,
          lastOn: DateUtil.dateText(row['last_on']) ?? '',
        ),
    ];
  }

  Future<Expense> create({
    required int groupId,
    required int? createdByUserId,
    required int? categoryId,
    required int amountCents,
    required String occurredOn,
    required String? note,
  }) async {
    String now = DateUtil.nowSql();
    return _q().create(<String, dynamic>{
      'group_id': groupId,
      'created_by_user_id': createdByUserId,
      'category_id': categoryId,
      'amount_cents': amountCents,
      'occurred_on': occurredOn,
      'note': note,
      'created_at': now,
      'updated_at': now,
    });
  }

  /// [values] uses column names.
  Future<Expense> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  /// Cascades to the account entry booked from this expense.
  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }

  /// Clears the category on every expense that uses it. Returns how many
  /// changed.
  Future<int> clearCategory(int categoryId) {
    return _q().where('category_id', categoryId).update(<String, dynamic>{
      'category_id': null,
    });
  }
}
