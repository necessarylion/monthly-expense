import 'package:api_dox/app/dtos/account/account.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account.repository.dart';
import 'package:api_dox/app/repositories/account_entry.repository.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/repositories/group.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:dox_core/dox_core.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// A balance is the signed sum of its entries. An account with no entries
/// is 0.
void main() {
  late TestApp app;
  late User user;
  int run = 0;

  T get<T extends Object>() => Dox().ioc.get<T>();

  setUpAll(() async {
    app = await TestApp.start();
  });

  tearDownAll(() async {
    await app.close();
  });

  setUp(() async {
    run++;
    user = await get<UserRepository>().create(
      firebaseUid: 'acct-$run',
      email: 'acct-$run@example.com',
      displayName: null,
      photoUrl: null,
    );
  });

  Future<Account> account(String name, String currency, {bool total = true}) {
    return get<AccountRepository>().create(
      userId: user.id!,
      name: name,
      currency: currency,
      color: '#000000',
      includeInTotal: total,
    );
  }

  test(
    'expense books an OUT entry in the member default account and dies with it',
    () async {
      AccountEntryRepository entries = get<AccountEntryRepository>();
      Account wallet = await account('Default', 'THB');
      Group group = await get<GroupRepository>().create(
        name: 'outflow',
        currency: 'THB',
        createdByUserId: null,
      );
      GroupMember member = await get<GroupMemberRepository>().create(
        groupId: group.id!,
        userId: user.id,
        email: user.email,
        invitedByUserId: null,
        joinedAt: null,
      );
      await get<GroupMemberRepository>().update(member.id!, <String, dynamic>{
        'default_account_id': wallet.id,
      });
      ExpenseRepository expenseRepo = get<ExpenseRepository>();
      Expense expense = await expenseRepo.create(
        groupId: group.id!,
        createdByUserId: user.id,
        categoryId: null,
        amountCents: 12345,
        occurredOn: '2026-08-19',
        note: 'Lunch',
      );

      await get<AccountService>().recordExpenseOutflow(user, expense, null);
      expect(await entries.balanceOf(wallet.id!), -12345);
      AccountEntry? entry = await entries.findByExpenseId(expense.id!);
      expect(entry?.note, 'Lunch');

      // Deleting the expense must cascade the booked entry away.
      await expenseRepo.delete(expense.id!);
      expect(await entries.findById(entry?.id ?? 0), isNull);
      expect(await entries.balanceOf(wallet.id!), 0);
    },
  );

  test('transfer writes one OUT and one IN entry', () async {
    Account from = await account('From', 'THB');
    Account to = await account('To', 'USD');

    await get<AccountService>().transfer(
      user,
      Transfer(
        fromAccountId: from.id!,
        toAccountId: to.id!,
        amount: 350, // ฿350 out
        toAmount: 10, // $10 in; cross-currency amounts are independent
        occurredOn: '2026-08-19',
      ),
    );

    AccountEntryRepository entries = get<AccountEntryRepository>();
    expect(await entries.balanceOf(from.id!), -35000);
    expect(await entries.balanceOf(to.id!), 1000);
  });

  test('sums pluses and minuses, and reports 0 for an empty account', () async {
    Account wallet = await account('Wallet', 'USD');
    await account('Empty', 'THB', total: false);
    AccountEntryRepository entries = get<AccountEntryRepository>();
    for (int cents in <int>[10000, -2550, 500]) {
      await entries.create(
        NewEntry(
          accountId: wallet.id!,
          amountCents: cents,
          occurredOn: '2026-08-19',
          note: null,
        ),
      );
    }

    expect(await entries.balanceOf(wallet.id!), 7950);
    List<AccountWithBalance> rows = await get<AccountService>().withBalances(
      user,
    );
    expect(
      <List<Object>>[
        for (AccountWithBalance row in rows)
          <Object>[row.account.name, row.balanceCents],
      ],
      <List<Object>>[
        <Object>['Empty', 0],
        <Object>['Wallet', 7950],
      ],
    );
    // SQLite gives 0/1. Clients need a real bool, not a number.
    for (AccountWithBalance row in rows) {
      expect(row.toJson()['includeInTotal'], isA<bool>());
    }
  });

  group('account entry amounts', () {
    test('accepts negative and positive, rejects zero', () async {
      CreateEntry out = await CreateEntry.schema.validateMap(<String, dynamic>{
        'amount': -250.75,
        'occurredOn': '2026-08-19',
        'note': 'ATM',
      });
      expect(MoneyUtil.toCents(out.amount), -25075);
      CreateEntry inbound = await CreateEntry.schema.validateMap(
        <String, dynamic>{'amount': 1000, 'occurredOn': '2026-08-19'},
      );
      expect(MoneyUtil.toCents(inbound.amount), 100000);

      expect(() => AccountService.assertNonZero(0), throwsA(isA<HttpError>()));
      // rounds to 0 cents
      expect(
        () => AccountService.assertNonZero(0.001),
        throwsA(isA<HttpError>()),
      );
      expect(() => AccountService.assertNonZero(-0.01), returnsNormally);
      ParseResult<CreateEntry> badDay = await CreateEntry.schema
          .safeValidateMap(<String, dynamic>{
            'amount': 1,
            'occurredOn': '2026-02-30',
          });
      expect(badDay.issues.single.code, 'date_format');
    });

    test('rounds halves like JavaScript', () {
      expect(MoneyUtil.toCents(12.345), 1235);
      expect(MoneyUtil.toCents(-0.005), 0);
      expect(MoneyUtil.toCents(0.1 + 0.2), 30);
    });
  });
}
