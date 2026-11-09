import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account.repository.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/row.dart';
import 'package:dox_orm/dox_orm.dart';

/// The fields of a new account entry.
class NewEntry {
  final int accountId;
  final int? expenseId;
  final int amountCents;
  final String occurredOn;
  final String? note;

  const NewEntry({
    required this.accountId,
    this.expenseId,
    required this.amountCents,
    required this.occurredOn,
    required this.note,
  });

  Map<String, dynamic> toRow(String now) {
    return <String, dynamic>{
      'account_id': accountId,
      'expense_id': expenseId,
      'amount_cents': amountCents,
      'occurred_on': occurredOn,
      'note': note,
      'created_at': now,
      'updated_at': now,
    };
  }
}

/// Net change of one account on one day.
class DailyChange {
  final int accountId;
  final String occurredOn;
  final int total;

  const DailyChange(this.accountId, this.occurredOn, this.total);
}

@Inject()
class AccountEntryRepository {
  static AccountEntry _q() => AccountEntry();

  /// For sums: rows of a `selectRaw` or `groupBy` are maps, not models.
  static QueryBuilder<Map<String, dynamic>> _rows() =>
      QueryBuilder.table('account_entries');

  Future<AccountEntry?> findById(int id) => _q().where('id', id).getFirst();

  Future<AccountEntry?> findByExpenseId(int expenseId) {
    return _q().where('expense_id', expenseId).getFirst();
  }

  /// One page of an account's ledger, newest first.
  Future<List<AccountEntry>> listByAccount(
    int accountId,
    int limit,
    int offset,
  ) {
    return _q()
        .where('account_id', accountId)
        .orderBy('occurred_on', 'desc')
        .orderBy('id', 'desc')
        .limit(limit)
        .offset(offset)
        .get();
  }

  /// The user's latest entries across all their accounts (owned and shared).
  Future<List<AccountEntry>> recentForUser(int userId, int limit, int offset) {
    return _q()
        .select('account_entries.*')
        .join('accounts', 'accounts.id', 'account_entries.account_id')
        .whereGroup((QueryBuilder<AccountEntry> q) {
          q
              .where('accounts.user_id', userId)
              .orWhereIn('accounts.id', AccountRepository.sharedIds(userId));
        })
        .orderBy('account_entries.occurred_on', 'desc')
        .orderBy('account_entries.id', 'desc')
        .limit(limit)
        .offset(offset)
        .get();
  }

  Future<int> balanceOf(int accountId) async {
    num? total = await _rows()
        .where('account_id', accountId)
        .sum('amount_cents');
    return DbRow.toInt(total) ?? 0;
  }

  /// Balance per account from entries dated before [before]. Missing = 0.
  Future<Map<int, int>> balancesBefore(List<int> accountIds, String before) {
    return _sums(
      _rows()
          .whereIn('account_id', accountIds)
          .where('occurred_on', '<', before),
    );
  }

  /// Net change per account per day, for days from [since] on.
  Future<List<DailyChange>> dailyChangesSince(
    List<int> accountIds,
    String since,
  ) async {
    if (accountIds.isEmpty) return <DailyChange>[];
    List<Map<String, dynamic>> rows = await _rows()
        .selectRaw('account_id, occurred_on, sum(amount_cents) as total')
        .whereIn('account_id', accountIds)
        .where('occurred_on', '>=', since)
        .groupBy(<String>['account_id', 'occurred_on'])
        .get();
    return <DailyChange>[
      for (Map<String, dynamic> row in rows)
        DailyChange(
          DbRow.toInt(row['account_id']) ?? 0,
          DateUtil.dateText(row['occurred_on']) ?? '',
          DbRow.toInt(row['total']) ?? 0,
        ),
    ];
  }

  /// Balance per account id. Accounts with no entries are not in the map.
  Future<Map<int, int>> balancesOf(List<int> accountIds) {
    return _sums(_rows().whereIn('account_id', accountIds));
  }

  Future<AccountEntry> create(NewEntry values) async {
    return _q().create(values.toRow(DateUtil.nowSql()));
  }

  /// Both rows are written, or neither.
  Future<(AccountEntry, AccountEntry)> createPair(
    NewEntry first,
    NewEntry second,
  ) async {
    return await QueryBuilder.transaction(() async {
      String now = DateUtil.nowSql();
      AccountEntry a = await _q().create(first.toRow(now));
      AccountEntry b = await _q().create(second.toRow(now));
      return (a, b);
    });
  }

  /// [values] uses column names.
  Future<AccountEntry> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(<String, dynamic>{
      ...values,
      'updated_at': DateUtil.nowSql(),
    });
    return (await findById(id))!;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }

  /// `sum(amount_cents)` per account of [query].
  static Future<Map<int, int>> _sums(
    QueryBuilder<Map<String, dynamic>> query,
  ) async {
    List<Map<String, dynamic>> rows = await query
        .selectRaw('account_id, sum(amount_cents) as total')
        .groupBy('account_id')
        .get();
    return <int, int>{
      for (Map<String, dynamic> row in rows)
        DbRow.toInt(row['account_id']) ?? 0: DbRow.toInt(row['total']) ?? 0,
    };
  }
}
