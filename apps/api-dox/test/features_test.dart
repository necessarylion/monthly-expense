import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/recurring.service.dart';
import 'package:api_dox/app/services/report.service.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Recurring expenses, category budgets, search, the year summary and
/// who owes whom.
void main() {
  late TestApp app;
  late int groupId;
  late int foodId;
  late int bobId;
  late int aliceId;

  Future<TestResponse> post(String path, Map<String, dynamic> body) {
    return app.call(path, method: 'POST', group: groupId, body: body);
  }

  Future<void> addExpense(
    num amount,
    String on, {
    String? note,
    int? accountId,
    String user = 'alice',
  }) async {
    TestResponse res = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      user: user,
      body: <String, dynamic>{
        'categoryId': foodId,
        'amount': amount,
        'occurredOn': on,
        'note': ?note,
        'accountId': ?accountId,
      },
    );
    res.expectStatus(201);
  }

  setUpAll(() async {
    app = await TestApp.start();
    aliceId = (await app.call('/api/v1/me')).json['data']['id'] as int;
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    TestResponse cats = await app.call('/api/v1/categories', group: groupId);
    foodId =
        (cats.json['data'] as List<dynamic>).firstWhere(
              (dynamic c) => c['slug'] == 'food',
            )['id']
            as int;
    await app.call(
      '/api/v1/groups/$groupId/invitations',
      method: 'POST',
      body: <String, dynamic>{'email': 'bob@gmail.com'},
    );
    bobId =
        (await app.call('/api/v1/me', user: 'bob')).json['data']['id'] as int;
  });

  tearDownAll(() async {
    await app.close();
  });

  group('recurring dates', () {
    test('a short month uses its last day', () {
      expect(RecurringService.dateOn(2026, 2, 31), '2026-02-28');
      expect(RecurringService.dateOn(2028, 2, 30), '2028-02-29');
      expect(RecurringService.dateOn(2026, 13, 5), '2027-01-05');
    });

    test('the first run is today or later', () {
      expect(RecurringService.firstRunOn('2026-11-09', 9), '2026-11-09');
      expect(RecurringService.firstRunOn('2026-11-09', 20), '2026-11-20');
      expect(RecurringService.firstRunOn('2026-11-09', 1), '2026-12-01');
      expect(RecurringService.firstRunOn('2026-12-31', 1), '2027-01-01');
    });

    test('the next run keeps the day after a short month', () {
      expect(RecurringService.nextRunOn('2026-02-28', 31), '2026-03-31');
      expect(RecurringService.nextRunOn('2026-01-31', 31), '2026-02-28');
    });
  });

  group('recurring expenses', () {
    test('today\'s day adds the expense at once, and only once', () async {
      String today = DateUtil.today();
      int day = int.parse(today.substring(8, 10));
      TestResponse created = await post('/api/v1/recurring', <String, dynamic>{
        'categoryId': foodId,
        'amount': 100,
        'dayOfMonth': day,
        'note': 'Rent',
      });
      created.expectStatus(201);
      expect(created.json['data']['nextOn'], isNot(today));

      // A second run finds nothing due.
      expect(await Dox().ioc.get<RecurringService>().runDue(), 0);

      TestResponse found = await app.call(
        '/api/v1/expenses/search?q=rent',
        group: groupId,
      );
      List<dynamic> rows = found.json['data'] as List<dynamic>;
      expect(rows, hasLength(1));
      expect(rows.first['occurredOn'], today);
      expect(rows.first['amountCents'], 10000);

      TestResponse list = await app.call('/api/v1/recurring', group: groupId);
      expect(list.json['data'], hasLength(1));
      int id = list.json['data'][0]['id'] as int;
      (await app.call(
        '/api/v1/recurring/$id',
        method: 'DELETE',
        group: groupId,
      )).expectStatus(204);
      // The expense it added stays.
      TestResponse after = await app.call(
        '/api/v1/expenses/search?q=rent',
        group: groupId,
      );
      expect(after.json['data'], hasLength(1));
    });

    test('a bad day is 422', () async {
      (await post('/api/v1/recurring', <String, dynamic>{
        'categoryId': foodId,
        'amount': 1,
        'dayOfMonth': 32,
      })).expectStatus(422);
    });
  });

  group('category budget', () {
    test('set and clear', () async {
      TestResponse set = await app.call(
        '/api/v1/categories/$foodId',
        method: 'PATCH',
        group: groupId,
        body: <String, dynamic>{'budget': 300},
      );
      expect(set.json['data']['budgetCents'], 30000);
      TestResponse cleared = await app.call(
        '/api/v1/categories/$foodId',
        method: 'PATCH',
        group: groupId,
        body: <String, dynamic>{'budget': null},
      );
      expect(cleared.json['data']['budgetCents'], isNull);
    });
  });

  group('search, year and balances', () {
    setUpAll(() async {
      // Bob's card, shared with Alice.
      TestResponse card = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        user: 'bob',
        body: <String, dynamic>{
          'name': 'Bob card',
          'currency': 'THB',
          'color': '#112233',
        },
      );
      int cardId = card.json['data']['id'] as int;
      (await app.call(
        '/api/v1/accounts/$cardId/members',
        method: 'POST',
        user: 'bob',
        body: <String, dynamic>{'email': 'alice@gmail.com'},
      )).expectStatus(201);

      await addExpense(30, '2025-03-02', note: 'Pizza night');
      // Alice logs it, but Bob's card paid it.
      await addExpense(10, '2025-03-05', note: 'Coffee', accountId: cardId);
      await addExpense(5, '2025-04-01', note: 'Coffee', user: 'bob');
    });

    test('search matches the note, the category and the dates', () async {
      TestResponse coffee = await app.call(
        '/api/v1/expenses/search?q=COFFEE&from=2025-01-01&to=2025-12-31',
        group: groupId,
      );
      expect(coffee.json['data'], hasLength(2));
      TestResponse byCategory = await app.call(
        '/api/v1/expenses/search?q=foo&from=2025-03-01&to=2025-03-31',
        group: groupId,
      );
      expect(byCategory.json['data'], hasLength(2));
    });

    test('the wallet owner paid; no wallet means who added it', () async {
      TestResponse res = await app.call(
        '/api/v1/expenses?month=2025-03',
        group: groupId,
      );
      Map<String, dynamic> byNote = <String, dynamic>{
        for (dynamic e in res.json['data'] as List<dynamic>) e['note']: e,
      };
      expect(byNote['Coffee']['createdByUserId'], aliceId);
      expect(byNote['Coffee']['paidByUserId'], bobId);
      expect(byNote['Pizza night']['paidByUserId'], aliceId);
    });

    test('year summary has 12 months', () async {
      TestResponse res = await app.call(
        '/api/v1/summary/year?year=2025',
        group: groupId,
      );
      Map<String, dynamic> data = res.json['data'] as Map<String, dynamic>;
      expect(data['totalCents'], 4500);
      expect(data['months'], hasLength(12));
      expect(data['months'][2], <String, dynamic>{
        'month': '2025-03',
        'totalCents': 4000,
      });
      expect(data['byCategory'][0]['categoryId'], foodId);
    });

    test('balances split the month equally', () async {
      TestResponse res = await app.call(
        '/api/v1/balances?month=2025-03',
        group: groupId,
      );
      Map<String, dynamic> data = res.json['data'] as Map<String, dynamic>;
      expect(data['totalCents'], 4000);
      // Alice paid 30, Bob 10; each share is 20, so Bob owes Alice 10.
      expect(data['transfers'], <dynamic>[
        <String, dynamic>{
          'fromUserId': bobId,
          'toUserId': aliceId,
          'amountCents': 1000,
        },
      ]);
    });
  });

  group('split setting', () {
    test('off by default, members can turn it on', () async {
      TestResponse groups = await app.call('/api/v1/groups');
      expect(
        (groups.json['data'] as List<dynamic>).first['splitEnabled'],
        false,
      );
      TestResponse on = await app.call(
        '/api/v1/groups/$groupId',
        method: 'PATCH',
        body: <String, dynamic>{'splitEnabled': true},
      );
      expect(on.json['data']['splitEnabled'], true);
    });
  });

  group('trip group', () {
    test('one budget, no months, split on by default', () async {
      TestResponse created = await app.call(
        '/api/v1/groups',
        method: 'POST',
        body: <String, dynamic>{
          'name': 'Chiang Mai',
          'kind': 'trip',
          'tripDays': 5,
        },
      );
      created.expectStatus(201);
      expect(created.json['data']['kind'], 'trip');
      expect(created.json['data']['tripDays'], 5);
      expect(created.json['data']['tripStart'], DateUtil.today());
      expect(created.json['data']['splitEnabled'], true);
      int trip = created.json['data']['id'] as int;

      TestResponse cats = await app.call('/api/v1/categories', group: trip);
      int cat = (cats.json['data'] as List<dynamic>).first['id'] as int;
      for (String on in <String>['2025-12-30', '2026-01-02']) {
        (await app.call(
          '/api/v1/expenses',
          method: 'POST',
          group: trip,
          body: <String, dynamic>{
            'categoryId': cat,
            'amount': 10,
            'occurredOn': on,
          },
        )).expectStatus(201);
      }
      (await app.call(
        '/api/v1/groups/$trip/budget',
        method: 'PUT',
        body: <String, dynamic>{'month': '2026-01', 'budget': 500},
      )).expectStatus(200);

      // Any month gives the whole trip.
      TestResponse summary = await app.call(
        '/api/v1/summary?month=2020-05',
        group: trip,
      );
      expect(summary.json['data']['totalCents'], 2000);
      expect(summary.json['data']['monthlyBudgetCents'], 50000);
      TestResponse list = await app.call(
        '/api/v1/expenses?month=2020-05',
        group: trip,
      );
      expect(list.json['data'], hasLength(2));
      TestResponse balances = await app.call(
        '/api/v1/balances?month=2020-05',
        group: trip,
      );
      expect(balances.json['data']['totalCents'], 2000);

      (await app.call(
        '/api/v1/recurring',
        method: 'POST',
        group: trip,
        body: <String, dynamic>{
          'categoryId': cat,
          'amount': 1,
          'dayOfMonth': 1,
        },
      )).expectStatus(422);

      TestResponse monthly = await app.call(
        '/api/v1/groups/$trip',
        method: 'PATCH',
        body: <String, dynamic>{'kind': 'monthly'},
      );
      expect(monthly.json['data']['kind'], 'monthly');
    });
  });

  group('review fixes', () {
    test('search treats % and _ as plain text', () async {
      await addExpense(1, '2024-06-01', note: 'Sale 50% off');
      await addExpense(1, '2024-06-02', note: 'Sale 500 off');
      TestResponse res = await app.call(
        '/api/v1/expenses/search?q=${Uri.encodeQueryComponent('50%')}&from=2024-06-01&to=2024-06-30',
        group: groupId,
      );
      expect(res.json['data'], hasLength(1));
      expect(res.json['data'][0]['note'], 'Sale 50% off');
    });

    test('a wallet owner outside the group is not the payer', () async {
      // Carol shares her wallet with Alice, but Carol is not in the group.
      await app.call('/api/v1/me', user: 'carol');
      TestResponse wallet = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        user: 'carol',
        body: <String, dynamic>{
          'name': 'Carol card',
          'currency': 'THB',
          'color': '#445566',
        },
      );
      int walletId = wallet.json['data']['id'] as int;
      (await app.call(
        '/api/v1/accounts/$walletId/members',
        method: 'POST',
        user: 'carol',
        body: <String, dynamic>{'email': 'alice@gmail.com'},
      )).expectStatus(201);
      TestResponse created = await post('/api/v1/expenses', <String, dynamic>{
        'categoryId': foodId,
        'amount': 7,
        'occurredOn': '2024-07-01',
        'accountId': walletId,
      });
      expect(created.json['data']['paidByUserId'], aliceId);
    });

    test('a trip ignores old monthly budgets, so clearing works', () async {
      TestResponse created = await app.call(
        '/api/v1/groups',
        method: 'POST',
        body: <String, dynamic>{'name': 'Was monthly'},
      );
      int id = created.json['data']['id'] as int;
      await app.call(
        '/api/v1/groups/$id/budget',
        method: 'PUT',
        body: <String, dynamic>{'month': '2026-01', 'budget': 1000},
      );
      await app.call(
        '/api/v1/groups/$id',
        method: 'PATCH',
        body: <String, dynamic>{'kind': 'trip'},
      );
      TestResponse summary = await app.call('/api/v1/summary', group: id);
      expect(summary.json['data']['monthlyBudgetCents'], isNull);
    });

    test('recurring stops when its creator leaves the group', () async {
      String today = DateUtil.today();
      TestResponse created = await app.call(
        '/api/v1/recurring',
        method: 'POST',
        group: groupId,
        user: 'bob',
        body: <String, dynamic>{
          'categoryId': foodId,
          'amount': 3,
          'dayOfMonth': 28,
          'note': 'Bob gym',
        },
      );
      created.expectStatus(201);
      int id = created.json['data']['id'] as int;
      (await app.call(
        '/api/v1/groups/$groupId/membership',
        method: 'DELETE',
        user: 'bob',
      )).expectStatus(204);
      // Make it due now.
      await RecurringExpense().where('id', id).update(<String, dynamic>{
        'next_on': today,
      });
      await Dox().ioc.get<RecurringService>().runDue();
      TestResponse found = await app.call(
        '/api/v1/expenses/search?q=${Uri.encodeQueryComponent('Bob gym')}',
        group: groupId,
      );
      expect(found.json['data'], isEmpty);
    });
  });

  group('settle', () {
    test('biggest debtor pays biggest creditor', () {
      MemberBalance a = MemberBalance(1, 'a')..paidCents = 90;
      MemberBalance b = MemberBalance(2, 'b');
      MemberBalance c = MemberBalance(3, 'c');
      for (MemberBalance row in <MemberBalance>[a, b, c]) {
        row.shareCents = 30;
      }
      List<SettleTransfer> out = ReportService.settle(<MemberBalance>[a, b, c]);
      expect(out.map((SettleTransfer t) => t.toJson()), <dynamic>[
        <String, dynamic>{'fromUserId': 2, 'toUserId': 1, 'amountCents': 30},
        <String, dynamic>{'fromUserId': 3, 'toUserId': 1, 'amountCents': 30},
      ]);
    });
  });
}
