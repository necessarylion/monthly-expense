import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Input rules the clients depend on: the 422 body, `""` as null, and
/// query numbers that fall back to the default.
void main() {
  late TestApp app;
  late int groupId;
  late int categoryId;

  setUpAll(() async {
    app = await TestApp.start();
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    TestResponse cats = await app.call('/api/v1/categories', group: groupId);
    categoryId = (cats.json['data'] as List<dynamic>).first['id'] as int;
  });

  tearDownAll(() async {
    await app.close();
  });

  test('a 422 has message and errors with field, message and rule', () async {
    TestResponse bad = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'categoryId': categoryId,
        'amount': 5,
        'occurredOn': '2026-02-30',
      },
    );
    bad.expectStatus(422);
    expect(bad.json, <String, dynamic>{
      'message': 'occurredOn: The occurredOn must match the format Y-m-d',
      'errors': <dynamic>[
        <String, dynamic>{
          'field': 'occurredOn',
          'message': 'occurredOn: The occurredOn must match the format Y-m-d',
          'rule': 'date_format',
        },
      ],
    });
  });

  test('PATCH note: "" clears the note, a missing note keeps it', () async {
    TestResponse created = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'categoryId': categoryId,
        'amount': 5,
        'occurredOn': '2026-08-01',
        'note': '  lunch  ',
      },
    );
    created.expectStatus(201);
    expect(created.json['data']['note'], 'lunch');
    int id = created.json['data']['id'] as int;

    TestResponse kept = await app.call(
      '/api/v1/expenses/$id',
      method: 'PATCH',
      group: groupId,
      body: <String, dynamic>{'amount': 6},
    );
    expect(kept.json['data']['note'], 'lunch');

    TestResponse cleared = await app.call(
      '/api/v1/expenses/$id',
      method: 'PATCH',
      group: groupId,
      body: <String, dynamic>{'note': ''},
    );
    cleared.expectStatus(200);
    expect(cleared.json['data'].containsKey('note'), isTrue);
    expect(cleared.json['data']['note'], isNull);
  });

  test('bad, zero or endless query numbers use the default', () async {
    TestResponse thirty = await app.call('/api/v1/accounts/history?days=30');
    Object? from = thirty.json['data']['from'];
    for (String days in <String>['abc', '0', 'Infinity', '']) {
      TestResponse res = await app.call('/api/v1/accounts/history?days=$days');
      res.expectStatus(200);
      expect(res.json['data']['from'], from, reason: 'days=$days');
    }
    // a real number is used (and clamped by the service)
    TestResponse two = await app.call('/api/v1/accounts/history?days=2');
    expect(two.json['data']['from'], isNot(from));
    for (String limit in <String>['abc', '0']) {
      (await app.call('/api/v1/accounts/recent-entries?limit=$limit&offset=x'))
          .expectStatus(200);
    }
  });

  test('a bad month query is a 422', () async {
    (await app.call(
      '/api/v1/summary?month=2026-13',
      group: groupId,
    )).expectStatus(422);
  });
}
