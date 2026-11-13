import 'package:api_dox/app/dtos/account/account.dto.dart';
import 'package:api_dox/app/serializers/account.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account.repository.dart';
import 'package:api_dox/app/repositories/account_entry.repository.dart';
import 'package:api_dox/app/repositories/account_member.repository.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/services/account_share.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/constants/live.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:dox_core/dox_core.dart';

/// End-of-day balances for the wallet cards.
class BalanceHistory {
  /// The first day in [balances]; one value per day from here to today.
  final String from;

  /// End-of-day balance in cents, per account id.
  final Map<int, List<int>> balances;

  const BalanceHistory(this.from, this.balances);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'from': from,
      'balances': <String, List<int>>{
        for (MapEntry<int, List<int>> e in balances.entries)
          e.key.toString(): e.value,
      },
    };
  }
}

/// An account with its balance, as the wallets list shows it.
class AccountWithBalance {
  final Account account;
  final int balanceCents;

  /// Legacy: old clients decode a non-optional isDefault.
  final bool isDefault;

  /// True when someone else can also use this account. Only in the list.
  final bool? shared;

  const AccountWithBalance(
    this.account,
    this.balanceCents,
    this.isDefault, [
    this.shared,
  ]);

  String get currency => account.currency;

  bool get includeInTotal => account.includeInTotal;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...AccountSerializer(account).toJson() as Map<String, dynamic>,
      'balanceCents': balanceCents,
      'isDefault': isDefault,
      if (shared != null) 'shared': shared,
    };
  }
}

/// Accounts are standalone balances owned by one user and shared with any
/// number of members (see AccountShareService). A balance is the sum of
/// its signed entries, so there is no stored total that can drift.
@Inject()
class AccountService {
  AccountService(
    this.accounts,
    this.entries,
    this.members,
    this.accountMembers,
    this.shares,
    this.live,
    this.expenses,
  );

  final AccountRepository accounts;
  final AccountEntryRepository entries;
  final GroupMemberRepository members;
  final AccountMemberRepository accountMembers;
  final AccountShareService shares;
  final LiveService live;
  final ExpenseRepository expenses;

  /// Pending wallet invites are claimed first: sign-in claims them only
  /// once, so this fixes one it missed.
  Future<List<AccountWithBalance>> withBalances(User user) async {
    await shares.claimPendingInvitations(user);
    List<Account> list = await accounts.listByUser(user.id!);
    if (list.isEmpty) return <AccountWithBalance>[];
    List<int> ids = <int>[for (Account account in list) account.id!];
    Map<int, int> balances = await entries.balancesOf(ids);
    Set<int> defaults = await members.defaultAccountIdsForUser(user.id!);
    Set<int> withMembers = await accountMembers.accountIdsWithMembers(ids);
    return <AccountWithBalance>[
      for (Account account in list)
        AccountWithBalance(
          account,
          balances[account.id] ?? 0,
          defaults.contains(account.id),
          account.userId != user.id || withMembers.contains(account.id),
        ),
    ];
  }

  /// End-of-day balances for the last [days] days (today included), for
  /// every account.
  Future<BalanceHistory> balanceHistory(User user, int days) async {
    List<Account> list = await accounts.listByUser(user.id!);
    List<int> ids = <int>[for (Account account in list) account.id!];
    String from = DateUtil.addDays(DateUtil.today(), -(days - 1));
    Map<int, int> start = await entries.balancesBefore(ids, from);
    List<DailyChange> changes = await entries.dailyChangesSince(ids, from);

    // Change per account per day index, then a running total.
    Map<String, int> dayIndex = <String, int>{
      for (int i = 0; i < days; i++) DateUtil.addDays(from, i): i,
    };
    Map<int, List<int>> perDay = <int, List<int>>{
      for (int id in ids) id: List<int>.filled(days, 0),
    };
    for (DailyChange change in changes) {
      int? i = dayIndex[change.occurredOn];
      List<int>? series = perDay[change.accountId];
      // Entries dated in the future (after today) are left out.
      if (i != null && series != null) series[i] += change.total;
    }
    Map<int, List<int>> balances = <int, List<int>>{};
    perDay.forEach((int id, List<int> series) {
      int running = start[id] ?? 0;
      balances[id] = <int>[for (int change in series) running += change];
    });
    return BalanceHistory(from, balances);
  }

  Future<Account> find(User user, int? id) async {
    Account? account = id == null ? null : await accounts.findById(id);
    if (account == null || !await canAccess(user, account)) {
      throw HttpError.notFound('Account not found');
    }
    return account;
  }

  /// The owner and every joined member can do everything with the account.
  Future<bool> canAccess(User user, Account account) async {
    if (account.userId == user.id) return true;
    return await accountMembers.findJoined(account.id!, user.id!) != null;
  }

  Future<AccountWithBalance> create(User user, CreateAccount input) async {
    Account account = await accounts.create(
      userId: user.id!,
      name: input.name,
      currency: input.currency,
      color: input.color,
      includeInTotal: input.includeInTotal ?? true,
    );
    if (input.isDefault != null) {
      await _applyLegacyDefault(user, account, input.isDefault!);
    }
    await live.accountChanged(account.id!);
    return AccountWithBalance(account, 0, input.isDefault ?? false);
  }

  Future<AccountWithBalance> update(
    User user,
    int? id,
    UpdateAccount input,
  ) async {
    Account account = await find(user, id);
    Map<String, dynamic> changes = <String, dynamic>{
      if (input.name != null) 'name': input.name,
      if (input.currency != null) 'currency': input.currency,
      if (input.color != null) 'color': input.color,
      if (input.includeInTotal != null)
        'include_in_total': input.includeInTotal,
    };
    if (input.isDefault != null) {
      await _applyLegacyDefault(user, account, input.isDefault!);
    }
    if (changes.isNotEmpty) {
      account = await accounts.update(account.id!, changes);
    }
    await live.accountChanged(account.id!);
    Set<int> defaults = await members.defaultAccountIdsForUser(user.id!);
    return AccountWithBalance(
      account,
      await entries.balanceOf(account.id!),
      defaults.contains(account.id),
    );
  }

  /// Its entries go with it (the foreign key cascades).
  Future<void> delete(User user, int? id) async {
    Account account = await find(user, id);
    Set<int> users = await live.usersOfAccount(account.id!);
    await accounts.delete(account.id!);
    await live.notify(users, liveTopicAccounts);
  }

  /// This member's pay-from account in the group.
  Future<int?> defaultAccountId(User user, Group group) async {
    GroupMember? membership = await members.findByGroupAndUser(
      group.id!,
      user.id!,
    );
    if (membership == null) throw HttpError.notFound('Membership not found');
    return membership.defaultAccountId;
  }

  /// Set (or clear, with null) the member's pay-from account in the group.
  Future<void> setDefaultAccountId(
    User user,
    Group group,
    int? accountId,
  ) async {
    if (accountId != null) await find(user, accountId);
    GroupMember? membership = await members.findByGroupAndUser(
      group.id!,
      user.id!,
    );
    if (membership == null) throw HttpError.notFound('Membership not found');
    await members.update(membership.id!, <String, dynamic>{
      'default_account_id': accountId,
    });
  }

  Future<AccountEntry> findEntry(Account account, int? id) async {
    AccountEntry? entry = id == null ? null : await entries.findById(id);
    if (entry == null || entry.accountId != account.id) {
      throw HttpError.notFound('Entry not found');
    }
    return entry;
  }

  Future<List<AccountEntry>> listEntries(
    Account account,
    int limit,
    int offset,
  ) {
    return entries.listByAccount(account.id!, limit, offset);
  }

  Future<List<AccountEntry>> recentEntries(User user, int limit, int offset) {
    return entries.recentForUser(user.id!, limit, offset);
  }

  Future<int> balanceOf(Account account) => entries.balanceOf(account.id!);

  Future<AccountEntry> createEntry(Account account, CreateEntry input) async {
    assertNonZero(input.amount);
    AccountEntry entry = await entries.create(
      NewEntry(
        accountId: account.id!,
        amountCents: MoneyUtil.toCents(input.amount),
        occurredOn: input.occurredOn,
        note: input.note,
      ),
    );
    await live.accountChanged(account.id!);
    return entry;
  }

  /// Set the balance to `input.balance` by booking one entry for the
  /// difference: 1000 -> 1500 books +500, 1000 -> 500 books -500. The
  /// current balance is read from the DB, so a stale screen cannot skew it.
  Future<AccountEntry> adjustBalance(
    Account account,
    AdjustBalance input,
  ) async {
    int current = await entries.balanceOf(account.id!);
    int difference = MoneyUtil.toCents(input.balance) - current;
    if (difference == 0) {
      throw HttpError.unprocessable('The balance is already this amount');
    }
    AccountEntry entry = await entries.create(
      NewEntry(
        accountId: account.id!,
        amountCents: difference,
        occurredOn: input.occurredOn,
        note: input.note ?? balanceAdjustmentNote,
      ),
    );
    await live.accountChanged(account.id!);
    return entry;
  }

  Future<AccountEntry> updateEntry(
    AccountEntry entry,
    UpdateEntry input,
  ) async {
    Map<String, dynamic> changes = <String, dynamic>{};
    if (input.amount != null) {
      assertNonZero(input.amount!);
      changes['amount_cents'] = MoneyUtil.toCents(input.amount!);
    }
    if (input.occurredOn != null) changes['occurred_on'] = input.occurredOn;
    if (input.note.isPresent) changes['note'] = input.note.value;
    if (changes.isEmpty) return entry;
    if (entry.expenseId != null) {
      return _updateExpenseEntry(entry, changes, input);
    }
    AccountEntry updated = await entries.update(entry.id!, changes);
    await live.accountChanged(entry.accountId);
    return updated;
  }

  /// An entry booked from an expense: the expense changes with it, so the
  /// two never show different numbers. It stays money out.
  ///
  /// ponytail: a new note does not ask Claude for a new category, as an
  /// expense edit does. Move this into ExpenseService if that matters.
  Future<AccountEntry> _updateExpenseEntry(
    AccountEntry entry,
    Map<String, dynamic> changes,
    UpdateEntry input,
  ) async {
    int? cents = changes['amount_cents'] as int?;
    if (cents != null && cents > 0) {
      throw HttpError.unprocessable('An expense is money out.');
    }
    Map<String, dynamic> expenseChanges = <String, dynamic>{
      'amount_cents': ?(cents == null ? null : -cents),
      'occurred_on': ?changes['occurred_on'],
      // An expense keeps its note; a cleared entry note leaves it as it is.
      'note': ?(input.note.isPresent ? input.note.value : null),
    };
    AccountEntry updated = await entries.update(entry.id!, changes);
    if (expenseChanges.isNotEmpty) {
      Expense expense = await expenses.update(entry.expenseId!, expenseChanges);
      await live.expenseChanged(expense.groupId, entry.accountId);
    } else {
      await live.accountChanged(entry.accountId);
    }
    return updated;
  }

  Future<void> deleteEntry(AccountEntry entry) async {
    await entries.delete(entry.id!);
    await live.accountChanged(entry.accountId);
  }

  /// Move money between two of the user's accounts: an OUT entry on the
  /// source and an IN entry on the destination, in one transaction.
  /// `toAmount` is for cross-currency transfers (defaults to `amount`).
  Future<(AccountEntry, AccountEntry)> transfer(
    User user,
    Transfer input,
  ) async {
    if (input.fromAccountId == input.toAccountId) {
      throw HttpError.unprocessable('Cannot transfer to the same account');
    }
    Account from = await find(user, input.fromAccountId);
    Account to = await find(user, input.toAccountId);
    String? note = input.note;
    (AccountEntry, AccountEntry) pair = await entries.createPair(
      NewEntry(
        accountId: from.id!,
        amountCents: -MoneyUtil.toCents(input.amount),
        occurredOn: input.occurredOn,
        note: note ?? '→ ${to.name}',
      ),
      NewEntry(
        accountId: to.id!,
        amountCents: MoneyUtil.toCents(input.toAmount ?? input.amount),
        occurredOn: input.occurredOn,
        note: note ?? '← ${from.name}',
      ),
    );
    await live.accountChanged(from.id!);
    await live.accountChanged(to.id!);
    return pair;
  }

  /// Adding an expense books a matching OUT entry in an account. Linked by
  /// `expenseId`, so deleting the expense deletes the entry.
  /// [hasAccountId] false = the member's default in this group;
  /// [accountId] null = none.
  ///
  /// ponytail: the amount is copied as-is, no FX. Convert here if a default
  /// account in another currency than the group becomes a real setup.
  Future<void> recordExpenseOutflow(
    User user,
    Expense expense,
    Category? category, {
    bool hasAccountId = false,
    int? accountId,
  }) async {
    if (hasAccountId && accountId == null) return;
    Account? account;
    if (hasAccountId) {
      account = await find(user, accountId);
    } else {
      GroupMember? membership = await members.findByGroupAndUser(
        expense.groupId,
        user.id!,
      );
      int? defaultId = membership?.defaultAccountId;
      account = defaultId == null ? null : await accounts.findById(defaultId);
      // A stale default (deleted, or no longer shared) books nothing.
      if (account != null && !await canAccess(user, account)) account = null;
    }
    if (account == null) return;
    await entries.create(
      NewEntry(
        accountId: account.id!,
        expenseId: expense.id,
        amountCents: -expense.amountCents,
        occurredOn: expense.occurredOn,
        note: expense.note ?? category?.name,
      ),
    );
  }

  /// Books the expense to another wallet, or to none ([accountId] null).
  /// The user must be able to use the old wallet and the new one.
  Future<void> moveExpenseOutflow(
    User user,
    Expense expense,
    int? accountId,
  ) async {
    AccountEntry? entry = await entries.findByExpenseId(expense.id!);
    if (entry?.accountId == accountId) return;
    if (entry != null) await find(user, entry.accountId);
    if (accountId == null) {
      await entries.delete(entry!.id!);
      return;
    }
    Account account = await find(user, accountId);
    if (entry != null) {
      await entries.update(entry.id!, <String, dynamic>{
        'account_id': account.id,
      });
      return;
    }
    await entries.create(
      NewEntry(
        accountId: account.id!,
        expenseId: expense.id,
        amountCents: -expense.amountCents,
        occurredOn: expense.occurredOn,
        note: expense.note,
      ),
    );
  }

  /// Keep the booked entry in step when its expense changes.
  Future<void> syncExpenseOutflow(Expense expense, Category? category) async {
    AccountEntry? entry = await entries.findByExpenseId(expense.id!);
    if (entry == null) return;
    await entries.update(entry.id!, <String, dynamic>{
      'amount_cents': -expense.amountCents,
      'occurred_on': expense.occurredOn,
      'note': expense.note ?? category?.name,
    });
  }

  /// Zero moves no money. Reject it instead of storing a no-op row.
  static void assertNonZero(num amount) {
    if (MoneyUtil.toCents(amount) == 0) {
      throw HttpError.unprocessable('Amount must not be zero');
    }
  }

  /// Old clients send a per-account isDefault. Map it onto every
  /// membership, which is close to the old "one global default" behavior.
  Future<void> _applyLegacyDefault(
    User user,
    Account account,
    bool isDefault,
  ) async {
    if (isDefault) {
      await members.setDefaultAccountForAllMemberships(user.id!, account.id!);
    } else {
      await members.clearDefaultAccount(user.id!, account.id!);
    }
  }
}
