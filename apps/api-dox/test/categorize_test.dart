import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// An expense with no category gets one from its note: the same note's
/// category from before, else Claude's pick, set after the answer.
void main() {
  late TestApp app;
  late int groupId;
  late int foodId;
  late int billsId;
  late FakeClaudeClient claude;

  Future<TestResponse> add(Map<String, dynamic> body) {
    return app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{'amount': 5, 'occurredOn': '2026-11-02', ...body},
    );
  }

  Future<int?> categoryOf(int id) async {
    TestResponse res = await app.call(
      '/api/v1/expenses?month=2026-11',
      group: groupId,
    );
    return (res.json['data'] as List<dynamic>).firstWhere(
          (dynamic e) => e['id'] == id,
        )['categoryId']
        as int?;
  }

  /// The category once the background pick is done (or null after a while).
  Future<int?> settled(int id) async {
    for (int i = 0; i < 50; i++) {
      int? category = await categoryOf(id);
      if (category != null) return category;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    return null;
  }

  setUpAll(() async {
    app = await TestApp.start();
    claude = Dox().ioc.get<ClaudeClient>() as FakeClaudeClient;
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    TestResponse cats = await app.call('/api/v1/categories', group: groupId);
    int slug(String s) =>
        (cats.json['data'] as List<dynamic>).firstWhere(
              (dynamic c) => c['slug'] == s,
            )['id']
            as int;
    foodId = slug('food');
    billsId = slug('bills');
  });

  tearDownAll(() => app.close());

  setUp(() {
    claude
      ..on = true
      ..answer = null
      ..calls = 0;
  });

  test('no category and no note: 422', () async {
    (await add(<String, dynamic>{})).expectStatus(422);
    expect(claude.calls, 0);
  });

  test('a new note: Claude picks the category after the answer', () async {
    claude.answer = <String, Object?>{'categoryId': billsId};
    TestResponse res = await add(<String, dynamic>{'note': 'Electricity'});
    res.expectStatus(201);
    int id = res.json['data']['id'] as int;
    expect(await settled(id), billsId);
    expect(claude.calls, 1);
  });

  test('a note used before: same category at once, no AI', () async {
    (await add(<String, dynamic>{'categoryId': foodId, 'note': 'Pad thai'}))
        .expectStatus(201);
    TestResponse res = await add(<String, dynamic>{'note': 'pad thai'});
    res.expectStatus(201);
    expect(res.json['data']['categoryId'], foodId);
    expect(claude.calls, 0);
  });

  test('an id outside the group is ignored', () async {
    claude.answer = <String, Object?>{'categoryId': 999999};
    TestResponse res = await add(<String, dynamic>{'note': 'Mystery'});
    int id = res.json['data']['id'] as int;
    expect(await settled(id), isNull);
    expect(claude.calls, 1);
  });

  test('Claude off: no category, still saved', () async {
    claude.on = false;
    TestResponse res = await add(<String, dynamic>{'note': 'Something new'});
    res.expectStatus(201);
    expect(res.json['data']['categoryId'], isNull);
  });

  test('a new note on edit sorts again; other edits do not', () async {
    claude.answer = <String, Object?>{'categoryId': foodId};
    TestResponse res = await add(<String, dynamic>{'note': 'Noodles'});
    int id = res.json['data']['id'] as int;
    expect(await settled(id), foodId);

    await app.call(
      '/api/v1/expenses/$id',
      method: 'PATCH',
      group: groupId,
      body: <String, dynamic>{'amount': 7},
    );
    expect(claude.calls, 1);

    claude.answer = <String, Object?>{'categoryId': billsId};
    (await app.call(
      '/api/v1/expenses/$id',
      method: 'PATCH',
      group: groupId,
      body: <String, dynamic>{'note': 'Water bill'},
    )).expectStatus(200);
    for (int i = 0; i < 50 && await categoryOf(id) != billsId; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(await categoryOf(id), billsId);
    expect(claude.calls, 2);
  });
}
