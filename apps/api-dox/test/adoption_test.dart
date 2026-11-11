import 'dart:io';

import 'package:api_dox/config/settings.dart';
import 'package:dox_core/testing.dart';
import 'package:dox_orm/dox_orm.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'support/test_app.dart';

/// The production database was written by the Bun API. Dox must take it
/// as it is: no table made again, every row read the same.
///
/// `test/fixtures/bun_api.sqlite3` was made by the Bun API's own migrator
/// and services (users `legacy` and `friend`, a shared wallet, entries,
/// expenses and a budget). SQLite only: production runs on SQLite.
void main() {
  if (onPostgres) {
    test('adopts a Bun database', () {}, skip: 'SQLite only');
    return;
  }

  late TestApp app;
  late String dbPath;

  setUpAll(() async {
    dbPath = settings.sqlitePath;
    // A fresh checkout (CI) has no storage/ folder yet.
    Directory dir = Directory(p.dirname(dbPath))..createSync(recursive: true);
    for (FileSystemEntity old in dir.listSync()) {
      if (p.basename(old.path).startsWith(p.basename(dbPath))) old.deleteSync();
    }
    File('test/fixtures/bun_api.sqlite3').copySync(dbPath);
    app = await TestApp.start(reset: false);
  });

  tearDownAll(() async {
    await app.close();
  });

  test('migrations adopt the Bun database and write a backup first', () async {
    List<String> backups = <String>[
      for (FileSystemEntity f in Directory(p.dirname(dbPath)).listSync())
        if (p.basename(f.path).startsWith('${p.basename(dbPath)}.backup-'))
          f.path,
    ];
    expect(backups, hasLength(1));

    List<Map<String, dynamic>> ran = await QueryBuilder.query(
      'SELECT migration FROM dox_db_migration ORDER BY migration',
    );
    expect(
      <Object?>[for (Map<String, dynamic> r in ran) r['migration']],
      <String>[
        '2026_11_08_000000_baseline',
        '2026_11_08_000001_account_members',
        // the fixture is older than Bun's 0002, so Dox makes this table
        '2026_11_09_000000_shopping_items',
        '2026_11_09_081253_create_mcp_tokens_table',
        '2026_11_09_130754_create_passkeys_table',
        '2026_11_09_134300_add_budgets_and_payers',
        '2026_11_09_134301_create_recurring_expenses_table',
        '2026_11_09_135608_add_split_to_groups',
        '2026_11_09_140558_add_kind_to_groups',
        '2026_11_09_141633_add_trip_dates_to_groups',
        '2026_11_10_210626_add_totp_to_users',
        '2026_11_10_220000_create_api_tokens_table',
        '2026_11_11_000000_create_access_tokens_table',
        '2026_11_11_000001_drop_api_tokens_table',
      ],
    );
    // the Bun migration table is left alone
    List<Map<String, dynamic>> kysely = await QueryBuilder.query(
      'SELECT name FROM kysely_migration ORDER BY name',
    );
    expect(kysely, hasLength(2));
  });

  test('the user, the group and its categories read the same', () async {
    TestResponse me = await app.call('/api/v1/me', user: 'legacy');
    expect(
      me.json['data'],
      matchesObject(<String, Object?>{
        'id': 1,
        'firebaseUid': 'legacy',
        'email': 'legacy@gmail.com',
        'displayName': 'Test legacy', // the fake token's name wins, as on Bun
      }),
    );
    TestResponse groups = await app.call('/api/v1/groups', user: 'legacy');
    expect(groups.json['data'], <dynamic>[
      <String, dynamic>{
        'id': 1,
        'name': "Legacy's Group",
        'currency': 'THB',
        'createdByUserId': 1,
        'splitEnabled': false,
        'kind': 'monthly',
        'tripStart': null,
        'tripDays': null,
      },
    ]);
    TestResponse cats = await app.call(
      '/api/v1/categories',
      user: 'legacy',
      group: 1,
    );
    expect(cats.json['data'], hasLength(8));
    expect(
      (cats.json['data'] as List<dynamic>).first['createdAt'],
      matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.000Z$')),
    );
  });

  test('expenses, the summary and the carried budget read the same', () async {
    TestResponse list = await app.call(
      '/api/v1/expenses?month=2026-10',
      user: 'legacy',
      group: 1,
    );
    List<dynamic> rows = list.json['data'] as List<dynamic>;
    expect(rows, hasLength(2));
    expect(
      rows.first,
      matchesObject(<String, Object?>{
        'amountCents': 725,
        'occurredOn': '2026-10-04',
        'note': null,
      }),
    );
    expect(
      rows.last,
      matchesObject(<String, Object?>{
        'amountCents': 1250,
        'occurredOn': '2026-10-03',
        'note': 'Noodles',
      }),
    );
    expect(rows.last['category'], containsPair('slug', 'food'));

    TestResponse summary = await app.call(
      '/api/v1/summary?month=2026-10',
      user: 'legacy',
      group: 1,
    );
    expect(summary.json['data']['totalCents'], 1975);
    expect(summary.json['data']['monthlyBudgetCents'], 500000);
  });

  test('wallets, balances, sharing and the default read the same', () async {
    TestResponse accounts = await app.call('/api/v1/accounts', user: 'legacy');
    expect(accounts.json['data'], <dynamic>[
      matchesObject(<String, Object?>{
        'name': 'Cash',
        'currency': 'THB',
        'includeInTotal': true,
        'balanceCents': 100000 - 1250,
        'isDefault': true,
        'shared': true,
      }),
      matchesObject(<String, Object?>{
        'name': 'Dollars',
        'currency': 'USD',
        'includeInTotal': false,
        'balanceCents': 2550,
        'isDefault': false,
        'shared': false,
      }),
    ]);
    TestResponse friend = await app.call('/api/v1/accounts', user: 'friend');
    expect(
      <Object?>[
        for (dynamic a in friend.json['data'] as List<dynamic>) a['name'],
      ],
      <String>['Cash'],
    );
    TestResponse entries = await app.call(
      '/api/v1/accounts/1/entries',
      user: 'friend',
    );
    expect(
      <Object?>[
        for (dynamic e in entries.json['data'] as List<dynamic>) e['note'],
      ],
      <String>['Noodles', 'Opening'],
    );
  });

  test('the old MCP link with the token in the path is gone', () async {
    List<Map<String, dynamic>> rows = await QueryBuilder.query(
      "SELECT mcp_token FROM users WHERE firebase_uid = 'legacy'",
    );
    String oldToken = '${rows.first['mcp_token']}';
    expect(oldToken, isNot('null'));
    // the column stays (never drop a column), but nothing reads it now
    TestResponse old = await app.client.post(
      '/mcp/$oldToken',
      headers: <String, String>{'content-type': 'application/json'},
      body: '{}',
    );
    old.expectStatus(404);
    TestResponse link = await app.call('/api/v1/me/mcp', user: 'legacy');
    expect(link.json['data']['url'], '${app.appUrl}/mcp');
    expect(link.json['data']['clients'], isEmpty);
  });

  test('new writes go next to the old rows', () async {
    TestResponse created = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      user: 'legacy',
      group: 1,
      body: <String, dynamic>{
        'categoryId': 1,
        'amount': 3,
        'occurredOn': '2026-10-05',
      },
    );
    created.expectStatus(201);
    List<Map<String, dynamic>> raw = await QueryBuilder.query(
      // a cast column is not converted by the driver: the stored text
      'SELECT CAST(occurred_on AS TEXT) AS day, '
      'CAST(created_at AS TEXT) AS at FROM expenses WHERE id = @id',
      substitutionValues: <String, dynamic>{'id': created.json['data']['id']},
    );
    // stored as text in the old formats, so old and new rows compare
    expect(
      raw.first['at'],
      matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$')),
    );
    expect(raw.first['day'], '2026-10-05');
  });
}
