import 'dart:async';

import 'package:api_dox/constants/live.dart';
import 'package:dox_core/testing.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Live updates over Socket.IO: a write by one user reaches the open apps
/// of the others who can see it, and nobody else.
void main() {
  late TestApp app;
  late int groupId;
  late int foodId;
  List<sio.Socket> sockets = <sio.Socket>[];

  setUpAll(() async {
    app = await TestApp.start();
    await app.call('/api/v1/me', user: 'bob');
    await app.call('/api/v1/me', user: 'carol');
    TestResponse groups = await app.call('/api/v1/groups');
    groupId = (groups.json['data'] as List<dynamic>).first['id'] as int;
    TestResponse cats = await app.call('/api/v1/categories', group: groupId);
    foodId =
        (cats.json['data'] as List<dynamic>).firstWhere(
              (dynamic c) => c['slug'] == 'food',
            )['id']
            as int;
    (await app.call(
      '/api/v1/groups/$groupId/invitations',
      method: 'POST',
      body: <String, dynamic>{'email': 'bob@gmail.com'},
    )).expectStatus(201);
  });

  tearDown(() {
    for (sio.Socket socket in sockets) {
      socket.dispose();
    }
    sockets.clear();
  });

  tearDownAll(() async {
    await app.close();
  });

  sio.Socket open(String token) {
    sio.Socket socket = sio.io(
      app.client.baseUri.toString(),
      sio.OptionBuilder()
          .setTransports(<String>['websocket'])
          .setAuth(<String, String>{'token': token})
          .disableReconnection()
          .enableForceNew()
          .build(),
    );
    sockets.add(socket);
    return socket;
  }

  /// A socket of [user] that is connected and collects every live event.
  Future<List<Object?>> listen(String user) async {
    sio.Socket socket = open(await app.tokenOf(user));
    List<Object?> events = <Object?>[];
    Completer<void> connected = Completer<void>();
    socket.onConnect((dynamic _) => connected.complete());
    socket.on(liveEvent, events.add);
    await connected.future.timeout(const Duration(seconds: 5));
    return events;
  }

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 300));

  test('a bad token can not connect', () async {
    sio.Socket socket = open('bad');
    Completer<Object?> refused = Completer<Object?>();
    socket.onConnectError(refused.complete);
    Object? error = await refused.future.timeout(const Duration(seconds: 5));
    expect(error.toString(), contains('Unauthorized'));
  });

  test('a Firebase ID token can not connect, only an API token', () async {
    sio.Socket socket = open('alice');
    Completer<Object?> refused = Completer<Object?>();
    socket.onConnectError(refused.complete);
    Object? error = await refused.future.timeout(const Duration(seconds: 5));
    expect(error.toString(), contains('Unauthorized'));
  });

  test('a new expense reaches the group members only', () async {
    List<Object?> alice = await listen('alice');
    List<Object?> bob = await listen('bob');
    List<Object?> carol = await listen('carol');

    (await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      user: 'bob',
      body: <String, dynamic>{
        'categoryId': foodId,
        'amount': 12,
        'occurredOn': dayFromToday(0),
      },
    )).expectStatus(201);
    await settle();

    Map<String, Object?> expected = <String, Object?>{
      'topic': liveTopicExpenses,
      'groupId': groupId,
    };
    expect(alice, <Object?>[expected]);
    expect(bob, <Object?>[expected]);
    expect(carol, isEmpty);
  });

  test('a wallet entry reaches the wallet users only', () async {
    TestResponse created = await app.call(
      '/api/v1/accounts',
      method: 'POST',
      body: <String, dynamic>{
        'name': 'Cash',
        'currency': 'THB',
        'color': '#3b82f6',
      },
    );
    int accountId = created.json['data']['id'] as int;
    List<Object?> alice = await listen('alice');
    List<Object?> bob = await listen('bob');

    (await app.call(
      '/api/v1/accounts/$accountId/entries',
      method: 'POST',
      body: <String, dynamic>{'amount': 50, 'occurredOn': dayFromToday(0)},
    )).expectStatus(201);
    await settle();

    expect(alice, <Object?>[
      <String, Object?>{'topic': liveTopicAccounts},
    ]);
    expect(bob, isEmpty);
  });

  test('deleting a booked expense reaches the shared wallet users', () async {
    TestResponse created = await app.call(
      '/api/v1/accounts',
      method: 'POST',
      body: <String, dynamic>{
        'name': 'Joint',
        'currency': 'THB',
        'color': '#3b82f6',
      },
    );
    int walletId = created.json['data']['id'] as int;
    (await app.call(
      '/api/v1/accounts/$walletId/members',
      method: 'POST',
      body: <String, dynamic>{'email': 'carol@gmail.com'},
    )).expectStatus(201);
    TestResponse expense = await app.call(
      '/api/v1/expenses',
      method: 'POST',
      group: groupId,
      body: <String, dynamic>{
        'categoryId': foodId,
        'amount': 5,
        'occurredOn': dayFromToday(0),
        'accountId': walletId,
      },
    );
    expense.expectStatus(201);
    int expenseId = expense.json['data']['id'] as int;

    // carol shares the wallet but is not in the group
    List<Object?> carol = await listen('carol');
    (await app.call(
      '/api/v1/expenses/$expenseId',
      method: 'DELETE',
      group: groupId,
    )).expectStatus(204);
    await settle();
    expect(carol, <Object?>[
      <String, Object?>{'topic': liveTopicAccounts},
    ]);
  });

  test('a removed member hears that the group changed', () async {
    TestResponse members = await app.call('/api/v1/groups/$groupId/members');
    int bobMember =
        (members.json['data'] as List<dynamic>).firstWhere(
              (dynamic m) => m['email'] == 'bob@gmail.com',
            )['id']
            as int;
    List<Object?> bob = await listen('bob');
    (await app.call(
      '/api/v1/groups/$groupId/members/$bobMember',
      method: 'DELETE',
    )).expectStatus(204);
    await settle();
    expect(bob, <Object?>[
      <String, Object?>{'topic': liveTopicGroup, 'groupId': groupId},
    ]);
  });
}
