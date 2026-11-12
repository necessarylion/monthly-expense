import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Smart add: Claude's items become checked cards, and a Save action
/// stores the expense with the checks of POST /expenses.
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

  Future<TestResponse> act(Map<String, dynamic> body) {
    return app.call(
      '/api/v1/smart-add/actions',
      method: 'POST',
      group: groupId,
      body: body,
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
    List<dynamic> messages = res.json['data']['messages'] as List<dynamic>;
    Map<String, dynamic> model =
        messages.firstWhere(
              (dynamic m) => m['updateDataModel'] != null,
            )['updateDataModel']
            as Map<String, dynamic>;
    List<dynamic> items = model['value']['items'] as List<dynamic>;
    expect(items, hasLength(2));
    expect(items.first['note'], 'lunch');
    expect(items.first['occurredOn'], '2026-11-12');
    expect(items.first['accountId'], defaultWallet);
    expect(items.first['categoryId'], foodId);
    // A made-up category is none: POST /expenses sorts it then.
    expect(items.last['categoryId'], isNull);
    List<dynamic> components =
        messages.firstWhere(
              (dynamic m) => m['updateComponents'] != null,
            )['updateComponents']['components']
            as List<dynamic>;
    Map<String, dynamic> button = components.firstWhere(
      (dynamic c) => c['id'] == 'save_0',
    ) as Map<String, dynamic>;
    expect(button['action']['event']['name'], 'save_expense');
    expect(button['action']['event']['context']['amount'], <String, dynamic>{
      'path': '/items/0/amount',
    });
    expect(
      button['action']['event']['context']['categoryId'],
      <String, dynamic>{'path': '/items/0/categoryId'},
    );
  });

  test('a broken answer is a 502', () async {
    TestResponse res = await read('not json');
    expect(res.status, 502);
  });

  test('Save stores the expense and turns the button into a label', () async {
    claude
      ..on = true
      ..calls = 0;
    TestResponse res = await act(<String, dynamic>{
      'name': 'save_expense',
      'sourceComponentId': 'save_0',
      'context': <String, dynamic>{
        'note': 'smart lunch',
        'amount': 5000,
        'occurredOn': '2026-11-12',
        'accountId': defaultWallet,
        'categoryId': foodId,
      },
    });
    expect(res.status, 200);
    List<dynamic> messages = res.json['data']['messages'] as List<dynamic>;
    Map<String, dynamic> label =
        (messages.first['updateComponents']['components'] as List<dynamic>)
                .first
            as Map<String, dynamic>;
    expect(label['id'], 'save_0');
    expect(label['component'], 'Text');

    TestResponse list = await app.call(
      '/api/v1/expenses?month=2026-11',
      group: groupId,
    );
    Map<String, dynamic> saved =
        (list.json['data'] as List<dynamic>).firstWhere(
          (dynamic e) => e['note'] == 'smart lunch',
        ) as Map<String, dynamic>;
    expect(saved['amountCents'], 500000);
    expect(saved['categoryId'], foodId);
    // The category came with the card: no second Claude call.
    expect(claude.calls, 0);
  });

  test('a bad action is refused like a bad POST /expenses', () async {
    Map<String, dynamic> good = <String, dynamic>{
      'note': 'x',
      'amount': 5,
      'occurredOn': '2026-11-12',
    };
    expect(
      (await act(<String, dynamic>{
        'name': 'delete_everything',
        'sourceComponentId': 'save_0',
        'context': good,
      })).status,
      422,
    );
    expect(
      (await act(<String, dynamic>{
        'name': 'save_expense',
        'sourceComponentId': 'root',
        'context': good,
      })).status,
      422,
    );
    expect(
      (await act(<String, dynamic>{
        'name': 'save_expense',
        'sourceComponentId': 'save_0',
        'context': <String, dynamic>{...good, 'amount': -1},
      })).status,
      422,
    );
    expect(
      (await act(<String, dynamic>{
        'name': 'save_expense',
        'sourceComponentId': 'save_0',
        'context': <String, dynamic>{...good, 'accountId': 999999},
      })).status,
      404,
    );
  });
}
