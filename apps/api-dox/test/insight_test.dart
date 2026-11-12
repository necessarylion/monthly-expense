import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// "Explain my month": Claude's A2UI answer becomes v0.9 JSON messages, and
/// a broken answer is a 502.
void main() {
  late TestApp app;
  late int groupId;
  late FakeClaudeClient claude;

  setUpAll(() async {
    app = await TestApp.start();
    claude = Dox().ioc.get<ClaudeClient>() as FakeClaudeClient;
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'amount': 12.5,
        'note': 'lunch',
        'occurredOn': '2026-11-02',
      },
    );
  });

  tearDownAll(() => app.close());

  test('sends the month to Claude and returns A2UI messages', () async {
    claude
      ..on = true
      ..answer = '''
<a2ui>
surface("month")
root = Column([Text("You spent 12.50 USD"), Divider()])
</a2ui>''';
    TestResponse res = await app.call(
      '/api/v1/insights/month?month=2026-11&lang=my',
      group: groupId,
    );
    expect(res.status, 200);
    expect(claude.lastPrompt, contains('"total":12.5'));
    expect(claude.lastPrompt, contains('Burmese'));
    List<dynamic> messages = res.json['data']['messages'] as List<dynamic>;
    expect(messages.first['version'], 'v0.9');
    expect(messages.first['createSurface']['surfaceId'], 'month');
    expect(messages.any((dynamic m) => m['updateComponents'] != null), isTrue);
  });

  test('the same month is not asked again until it changes', () async {
    int before = claude.calls;
    TestResponse again = await app.call(
      '/api/v1/insights/month?month=2026-11&lang=my',
      group: groupId,
    );
    expect(again.status, 200);
    expect(claude.calls, before, reason: 'served from the cache');

    await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'amount': 3,
        'note': 'tea',
        'occurredOn': '2026-11-03',
      },
    );
    await app.call(
      '/api/v1/insights/month?month=2026-11&lang=my',
      group: groupId,
    );
    expect(claude.calls, greaterThan(before), reason: 'a new expense asks');
    expect(claude.lastPrompt, contains('"expenseCount":2'));
  });

  // As bob: the AI rate limit is per user, and alice used hers above.
  test('a broken answer is a 502, and is not cached', () async {
    TestResponse groups = await app.call('/api/v1/groups', user: 'bob');
    int bobGroup = (groups.json['data'] as List<dynamic>).first['id'] as int;
    claude
      ..on = true
      ..answer = '<a2ui>root = NotAComponent()</a2ui>';
    Future<TestResponse> ask() => app.call(
      '/api/v1/insights/month?month=2026-10',
      user: 'bob',
      group: bobGroup,
    );
    expect((await ask()).status, 502);
    int before = claude.calls;
    await ask();
    expect(claude.calls, before + 1);
  });
}
