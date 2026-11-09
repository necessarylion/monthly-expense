import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// A shared wallet works fully for every member.
void main() {
  late TestApp app;

  setUpAll(() async {
    app = await TestApp.start();
  });

  tearDownAll(() async {
    await app.close();
  });

  Future<TestResponse> call(
    String user,
    String path, [
    String method = 'GET',
    Object? body,
  ]) {
    return app.call('/api/v1$path', user: user, method: method, body: body);
  }

  test('a shared account works fully for both users', () async {
    await call('bob', '/me'); // bob exists, so his invite joins at once
    TestResponse created = await call(
      'alice',
      '/accounts',
      'POST',
      <String, dynamic>{'name': 'Joint', 'currency': 'THB', 'color': '#3b82f6'},
    );
    int id = created.json['data']['id'] as int;

    // Outsiders cannot see it or share it.
    (await call('bob', '/accounts/$id/entries')).expectStatus(404);
    (await call('bob', '/accounts/$id/members', 'POST', <String, dynamic>{
      'email': 'x@gmail.com',
    })).expectStatus(404);

    (await call('alice', '/accounts/$id/members', 'POST', <String, dynamic>{
      'email': 'bob@yahoo.com',
    })).expectStatus(422);
    (await call('alice', '/accounts/$id/members', 'POST', <String, dynamic>{
      'email': 'alice@gmail.com',
    })).expectStatus(422);
    TestResponse invited = await call(
      'alice',
      '/accounts/$id/members',
      'POST',
      <String, dynamic>{'email': 'Bob@Gmail.com'},
    );
    invited.expectStatus(201);
    expect(
      invited.json['data'],
      matchesObject(<String, Object?>{
        'email': 'bob@gmail.com',
        'pending': false,
        'owner': false,
      }),
    );

    // Bob sees it and can do everything: entries, rename, share further.
    TestResponse bobList = await call('bob', '/accounts');
    expect(
      <Object?>[
        for (dynamic a in bobList.json['data'] as List<dynamic>) a['name'],
      ],
      <String>['Joint'],
    );
    (await call('bob', '/accounts/$id/entries', 'POST', <String, dynamic>{
      'amount': 100,
      'occurredOn': '2026-11-01',
    })).expectStatus(201);
    (await call('bob', '/accounts/$id', 'PATCH', <String, dynamic>{
      'name': 'Shared',
    })).expectStatus(200);
    expect(
      (await call('bob', '/accounts/recent-entries')).json['data'],
      hasLength(1),
    );
    TestResponse carol = await call(
      'bob',
      '/accounts/$id/members',
      'POST',
      <String, dynamic>{'email': 'carol@gmail.com'},
    );
    expect(carol.json['data']['pending'], isTrue);

    TestResponse aliceList = await call('alice', '/accounts');
    expect(
      (aliceList.json['data'] as List<dynamic>).first,
      matchesObject(<String, Object?>{
        'name': 'Shared',
        'balanceCents': 10000,
        'shared': true,
      }),
    );
    expect((bobList.json['data'] as List<dynamic>).first['shared'], isTrue);

    // Carol joins on her first sign-in.
    await call('carol', '/me');
    expect((await call('carol', '/accounts')).json['data'], hasLength(1));

    List<dynamic> members =
        (await call('alice', '/accounts/$id/members')).json['data']
            as List<dynamic>;
    expect(
      <List<Object?>>[
        for (dynamic m in members) <Object?>[m['email'], m['owner']],
      ],
      <List<Object?>>[
        <Object?>['alice@gmail.com', true],
        <Object?>['bob@gmail.com', false],
        <Object?>['carol@gmail.com', false],
      ],
    );

    // Bob leaves by removing himself; then he loses access.
    dynamic bobRow = members.firstWhere(
      (dynamic m) => m['email'] == 'bob@gmail.com',
    );
    (await call(
      'bob',
      '/accounts/$id/members/${bobRow['id']}',
      'DELETE',
    )).expectStatus(204);
    expect((await call('bob', '/accounts')).json['data'], hasLength(0));
    (await call('bob', '/accounts/$id/entries')).expectStatus(404);

    // A member can delete the account for everyone.
    (await call('carol', '/accounts/$id', 'DELETE')).expectStatus(204);
    expect((await call('alice', '/accounts')).json['data'], hasLength(0));
  });
}
