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

  /// Sets [Expense.walletOwnerId] on each expense that was paid from a
  /// wallet: the wallet's owner paid it. An owner who is not a joined
  /// member of the expense's group (a wallet shared from outside) is left
  /// out, so the person who added it counts as the payer.
  Future<void> attachWalletOwners(List<Expense> rows) async {
    List<int> ids = <int>[for (Expense e in rows) e.id!];
    if (ids.isEmpty) return;
    List<Map<String, dynamic>> owners =
        await QueryBuilder.table('account_entries')
            .select(
              'account_entries.expense_id, account_entries.account_id, '
              'accounts.user_id',
            )
            .join('accounts', 'accounts.id', 'account_entries.account_id')
            .whereIn('account_entries.expense_id', ids)
            .get();
    Set<int> groupIds = <int>{for (Expense e in rows) e.groupId};
    List<Map<String, dynamic>> joined =
        await QueryBuilder.table('group_members')
            .select('group_id, user_id')
            .whereIn('group_id', groupIds.toList())
            .whereNotNull('user_id')
            .whereNotNull('joined_at')
            .get();
    Set<String> isMember = <String>{
      for (Map<String, dynamic> row in joined)
        '${DbRow.toInt(row['group_id'])}:${DbRow.toInt(row['user_id'])}',
    };
    Map<int, int> byExpense = <int, int>{
      for (Map<String, dynamic> row in owners)
        DbRow.toInt(row['expense_id'])!: DbRow.toInt(row['user_id'])!,
    };
    Map<int, int> accountByExpense = <int, int>{
      for (Map<String, dynamic> row in owners)
        DbRow.toInt(row['expense_id'])!: DbRow.toInt(row['account_id'])!,
    };
    for (Expense e in rows) {
      e.walletAccountId = accountByExpense[e.id];
      int? owner = byExpense[e.id];
      bool member = owner != null && isMember.contains('${e.groupId}:$owner');
      e.walletOwnerId = member ? owner : null;
    }
  }

  /// Expenses that match every given filter, newest first, at most
  /// [limit]. [text] matches the note; [textCategoryIds] are categories
  /// whose name matched it, so those match too.
  Future<List<Expense>> search({
    required int groupId,
    String? text,
    List<int> textCategoryIds = const <int>[],
    int? categoryId,
    String? from,
    String? to,
    required int limit,
  }) {
    QueryBuilder<Expense> q = _q().where('group_id', groupId);
    if (categoryId != null) q = q.where('category_id', categoryId);
    if (from != null) q = q.where('occurred_on', '>=', from);
    if (to != null) q = q.where('occurred_on', '<=', to);
    if (text != null) {
      // `!` escapes `%` and `_`, so they match themselves. ESCAPE works the
      // same on SQLite and Postgres.
      String escaped = text
          .toLowerCase()
          .replaceAll('!', '!!')
          .replaceAll('%', '!%')
          .replaceAll('_', '!_');
      q = q.whereGroup((QueryBuilder<Expense> g) {
        g.whereRaw("lower(note) LIKE @text ESCAPE '!'", <String, dynamic>{
          'text': '%$escaped%',
        });
        if (textCategoryIds.isNotEmpty) {
          g.orWhereIn('category_id', textCategoryIds);
        }
      });
    }
    return q
        .orderBy('occurred_on', 'desc')
        .orderBy('id', 'desc')
        .limit(limit)
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

  /// The category of the group's newest expense with this note (case is
  /// ignored). Null when there is none.
  Future<int?> categoryOfNote(int groupId, String note) async {
    Expense? row = await _q()
        .where('group_id', groupId)
        .whereNotNull('category_id')
        .whereRaw('lower(note) = @note', <String, dynamic>{
          'note': note.toLowerCase(),
        })
        .orderBy('id', 'desc')
        .getFirst();
    return row?.categoryId;
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
