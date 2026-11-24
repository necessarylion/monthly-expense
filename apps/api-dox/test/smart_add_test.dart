import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Smart add: Claude's items come back checked, with the keys of
/// POST /expenses. The app saves them with POST /expenses.
void main() {
  late TestApp app;
  late int groupId;
  late int? defaultWallet;
  late int foodId;
  late FakeClaudeClient claude;

  Future<TestResponse> read(Object? answer) {
    claude
      ..on = true
      ..answer = answer;
    return app.call(
      '/api/v1/smart-add',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'text': 'lunch 5000, taxi 3000',
        'today': '2026-11-12',
      },
    );
  }

  setUpAll(() async {
    app = await TestApp.start();
    claude = Dox().ioc.get<ClaudeClient>() as FakeClaudeClient;
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    TestResponse wallet = await app.call(
      '/api/v1/default-account',
      group: groupId,
    );
    defaultWallet = wallet.json['data']?['accountId'] as int?;
    TestResponse categories = await app.call(
      '/api/v1/categories',
      group: groupId,
    );
    foodId = (categories.json['data'] as List<dynamic>).first['id'] as int;
  });

  tearDownAll(() => app.close());

  test('keeps good items only, and a made-up wallet is the default', () async {
    TestResponse res = await read(<String, dynamic>{
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'note': ' lunch ',
          'amount': 5000,
          'walletId': 999,
          'categoryId': foodId,
        },
        <String, dynamic>{
          'note': 'taxi',
          'amount': 3000,
          'walletId': null,
          'categoryId': 999999,
        },
        <String, dynamic>{'note': '', 'amount': 10, 'walletId': null},
        <String, dynamic>{'note': 'gift', 'amount': -5, 'walletId': null},
      ],
    });
    expect(res.status, 200);
    expect(claude.lastPrompt, contains('lunch 5000, taxi 3000'));
    expect(claude.lastPrompt, contains('"categories"'));
    List<dynamic> items = res.json['data']['items'] as List<dynamic>;
    expect(items, hasLength(2));
    expect(items.first['note'], 'lunch');
    expect(items.first['occurredOn'], '2026-11-12');
    expect(items.first['accountId'], defaultWallet);
    expect(items.first['categoryId'], foodId);
    // A made-up category is none: POST /expenses sorts it then.
    expect(items.last['categoryId'], isNull);
    // An item is a ready body of POST /expenses.
    claude.calls = 0;
    TestResponse saved = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: items.first as Map<String, dynamic>,
    );
    expect(saved.status, 201);
    expect(saved.json['data']['amountCents'], 500000);
    expect(saved.json['data']['categoryId'], foodId);
    // The category came with the item: no second Claude call.
    expect(claude.calls, 0);
  });

  test('a broken answer is a 502', () async {
    TestResponse res = await read('not json');
    expect(res.status, 502);
  });
}
