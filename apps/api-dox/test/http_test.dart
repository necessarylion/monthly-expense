import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;

import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// The HTTP contract of the API, over a real server.
void main() {
  late TestApp app;
  late int groupId;

  setUpAll(() async {
    app = await TestApp.start();
  });

  tearDownAll(() async {
    await app.close();
  });

  group('auth and profile', () {
    test('health check needs no token', () async {
      TestResponse res = await app.call('/healthz', user: '');
      res.expectStatus(200).expectJson(<String, dynamic>{
        'name': 'monthly-expense-api',
        'status': 'ok',
      });
    });

    test('config.js sends the Firebase web config, no token', () async {
      TestResponse res = await app.call('/config.js', user: '');
      res
          .expectStatus(200)
          .expectHeader('content-type', contains('application/javascript'));
      const String prefix = 'window.__APP_CONFIG__ = ';
      expect(res.body, startsWith(prefix));
      String json = res.body.substring(prefix.length).trim();
      Map<String, dynamic> config = jsonDecode(
        json.substring(0, json.length - 1),
      ) as Map<String, dynamic>;
      expect(
        config.keys,
        containsAll(<String>['apiKey', 'authDomain', 'projectId', 'appId']),
      );
    });

    test('missing and bad tokens are 401 with a message', () async {
      (await app.call('/api/v1/me', user: '')).expectStatus(401).expectJson(
        <String, dynamic>{'message': 'Missing bearer token'},
      );
      (await app.call('/api/v1/me', user: 'bad')).expectStatus(401).expectJson(
        <String, dynamic>{'message': 'Invalid Firebase ID token'},
      );
    });

    test(
      'Firebase not answering is 503, not 401 (a 401 logs the user out)',
      () async {
        (await app.call('/api/v1/me', user: 'down')).expectStatus(503);
      },
    );

    test('first sign-in creates the user and a personal group with default categories', () async {
      TestResponse me = await app.call('/api/v1/me');
      Map<String, dynamic> data = me.json['data'] as Map<String, dynamic>;
      expect(
        data,
        matchesObject(<String, Object?>{
          'firebaseUid': 'alice',
          'email': 'alice@gmail.com',
          'displayName': 'Test alice',
        }),
      );
      expect(data.containsKey('mcpToken'), isFalse);

      TestResponse groups = await app.call('/api/v1/groups');
      List<dynamic> list = groups.json['data'] as List<dynamic>;
      expect(list, hasLength(1));
      expect(
        list.first,
        matchesObject(<String, Object?>{
          'name': "Test's Group",
          'currency': 'THB',
        }),
      );
      groupId = list.first['id'] as int;

      TestResponse cats = await app.call('/api/v1/categories', group: groupId);
      List<dynamic> categories = cats.json['data'] as List<dynamic>;
      expect(categories, hasLength(8));
      expect(categories.first['name'], 'Bills'); // sorted by name
    });

    test(
      'parallel first sign-in requests make one user and one group',
      () async {
        List<TestResponse> all = await Future.wait(<Future<TestResponse>>[
          for (int i = 0; i < 5; i++) app.call('/api/v1/me', user: 'racer'),
        ]);
        for (TestResponse res in all) {
          res.expectStatus(200);
        }
        TestResponse groups = await app.call('/api/v1/groups', user: 'racer');
        expect(groups.json['data'] as List<dynamic>, hasLength(1));
      },
    );

    test('group routes need X-Group-Id', () async {
      (await app.call('/api/v1/categories')).expectStatus(400);
      (await app.call(
        '/api/v1/categories',
        headers: <String, String>{'x-group-id': '999'},
      )).expectStatus(404);
    });
  });

  group('expenses and accounts', () {
    late int accountId;
    late int expenseId;
    late int foodId;

    test('create an account and make it the default for the group', () async {
      TestResponse created = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        body: <String, dynamic>{
          'name': 'Wallet',
          'currency': 'thb',
          'color': '#112233',
        },
      );
      created.expectStatus(201);
      expect(
        created.json['data'],
        matchesObject(<String, Object?>{
          'name': 'Wallet',
          'currency': 'THB',
          'includeInTotal': true,
          'balanceCents': 0,
          'isDefault': false,
        }),
      );
      accountId = created.json['data']['id'] as int;

      TestResponse set = await app.call(
        '/api/v1/default-account',
        method: 'PUT',
        group: groupId,
        body: <String, dynamic>{'accountId': accountId},
      );
      expect(set.json['data'], <String, dynamic>{'accountId': accountId});
      TestResponse get = await app.call(
        '/api/v1/default-account',
        group: groupId,
      );
      expect(get.json['data'], <String, dynamic>{'accountId': accountId});
    });

    test('validation errors are 422 with a message', () async {
      TestResponse bad = await app.call(
        '/api/v1/expenses',
        method: 'POST',
        group: groupId,
        body: <String, dynamic>{'amount': 0},
      );
      bad.expectStatus(422);
      expect(bad.json['message'], isA<String>());
      expect(bad.json['errors'], isA<List<dynamic>>());
      expect(
        (bad.json['errors'] as List<dynamic>).first,
        allOf(containsPair('field', isA<String>()), contains('rule')),
      );
    });

    test('an expense books an OUT entry in the default account', () async {
      TestResponse cats = await app.call('/api/v1/categories', group: groupId);
      foodId =
          (cats.json['data'] as List<dynamic>).firstWhere(
                (dynamic c) => c['slug'] == 'food',
              )['id']
              as int;
      TestResponse created = await app.call(
        '/api/v1/expenses',
        method: 'POST',
        group: groupId,
        body: <String, dynamic>{
          'categoryId': foodId,
          'amount': 12.5,
          'occurredOn': '2026-08-18',
          'note': '',
        },
      );
      created.expectStatus(201);
      Map<String, dynamic> data = created.json['data'] as Map<String, dynamic>;
      expect(
        data,
        matchesObject(<String, Object?>{
          'amountCents': 1250,
          'occurredOn': '2026-08-18',
          'note': null,
          'categoryId': foodId,
        }),
      );
      expect(
        data['category'],
        matchesObject(<String, Object?>{'id': foodId, 'slug': 'food'}),
      );
      expect(
        data['createdAt'],
        matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.000Z$')),
      );
      expenseId = data['id'] as int;

      TestResponse accounts = await app.call('/api/v1/accounts');
      expect(
        (accounts.json['data'] as List<dynamic>).first,
        matchesObject(<String, Object?>{
          'id': accountId,
          'balanceCents': -1250,
          'isDefault': true,
        }),
      );
    });

    test('list and summary for the month', () async {
      TestResponse list = await app.call(
        '/api/v1/expenses?month=2026-08',
        group: groupId,
      );
      expect(list.json['data'], hasLength(1));
      expect(
        (await app.call(
          '/api/v1/expenses?month=2026-07',
          group: groupId,
        )).json['data'],
        hasLength(0),
      );
      (await app.call(
        '/api/v1/expenses?month=2026-13',
        group: groupId,
      )).expectStatus(422);

      await app.call(
        '/api/v1/groups/$groupId/budget',
        method: 'PUT',
        body: <String, dynamic>{'month': '2026-06', 'budget': 8000},
      );
      TestResponse summary = await app.call(
        '/api/v1/summary?month=2026-08',
        group: groupId,
      );
      expect(summary.json['data'], <String, dynamic>{
        'month': '2026-08',
        'totalCents': 1250,
        'count': 1,
        'monthlyBudgetCents': 800000, // carried forward from June
        'byCategory': <dynamic>[
          <String, dynamic>{
            'categoryId': foodId,
            'totalCents': 1250,
            'count': 1,
          },
        ],
      });
    });

    test('updating the expense keeps the booked entry in step', () async {
      TestResponse updated = await app.call(
        '/api/v1/expenses/$expenseId',
        method: 'PATCH',
        group: groupId,
        body: <String, dynamic>{'amount': 20},
      );
      expect(updated.json['data']['amountCents'], 2000);
      TestResponse entries = await app.call(
        '/api/v1/accounts/$accountId/entries',
      );
      expect(
        (entries.json['data'] as List<dynamic>).first,
        matchesObject(<String, Object?>{
          'amountCents': -2000,
          'expenseId': expenseId,
          'note': 'Food',
        }),
      );
    });

    test('total, transfer and recent entries', () async {
      TestResponse savings = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        body: <String, dynamic>{
          'name': 'Savings',
          'currency': 'THB',
          'color': '#445566',
        },
      );
      TestResponse transfer = await app.call(
        '/api/v1/accounts/transfers',
        method: 'POST',
        body: <String, dynamic>{
          'fromAccountId': savings.json['data']['id'],
          'toAccountId': accountId,
          'amount': 100,
          'occurredOn': '2026-08-19',
        },
      );
      transfer.expectStatus(201);
      expect(
        transfer.json['data']['out'],
        matchesObject(<String, Object?>{
          'amountCents': -10000,
          'note': '→ Wallet',
        }),
      );
      expect(
        transfer.json['data']['in'],
        matchesObject(<String, Object?>{
          'amountCents': 10000,
          'note': '← Savings',
        }),
      );

      TestResponse total = await app.call(
        '/api/v1/accounts/total?currency=THB',
      );
      expect(total.json['data'], <String, dynamic>{
        'currency': 'THB',
        'totalCents': -2000,
        'approx': false,
        'rates': <String, dynamic>{},
        'gold': null,
      });

      TestResponse recent = await app.call(
        '/api/v1/accounts/recent-entries?limit=2',
      );
      recent.expectStatus(200);
      expect(recent.json['data'], hasLength(2));
    });

    test('deleting the expense removes the booked entry', () async {
      (await app.call(
        '/api/v1/expenses/$expenseId',
        method: 'DELETE',
        group: groupId,
      )).expectStatus(204);
      TestResponse entries = await app.call(
        '/api/v1/accounts/$accountId/entries',
      );
      for (dynamic entry in entries.json['data'] as List<dynamic>) {
        expect(entry['expenseId'], isNull);
      }
    });
  });

  group('invites', () {
    test(
      'only gmail addresses, and the invite is claimed on sign-in',
      () async {
        String path = '/api/v1/groups/$groupId/invitations';
        (await app.call(
          path,
          method: 'POST',
          body: <String, dynamic>{'email': 'x@example.com'},
        )).expectStatus(422);
        TestResponse invite = await app.call(
          path,
          method: 'POST',
          body: <String, dynamic>{'email': 'Bob@Gmail.com'},
        );
        expect(
          invite.json['data'],
          matchesObject(<String, Object?>{
            'email': 'bob@gmail.com',
            'pending': true,
            'userId': null,
            'joinedAt': null,
          }),
        );

        await app.call('/api/v1/me', user: 'bob');
        TestResponse bobGroups = await app.call('/api/v1/groups', user: 'bob');
        List<dynamic> ids = <dynamic>[
          for (dynamic g in bobGroups.json['data'] as List<dynamic>) g['id'],
        ];
        expect(ids, contains(groupId));
      },
    );
  });

  group('http plumbing', () {
    test('CORS preflight and headers for allowed origins only', () async {
      TestResponse pre = await app.client.send(
        'OPTIONS',
        '/api/v1/me',
        headers: <String, String>{
          'origin': 'http://localhost:5173',
          'access-control-request-method': 'GET',
          'access-control-request-headers': 'authorization,x-group-id',
        },
      );
      pre.expectStatus(204);
      expect(
        pre.header('access-control-allow-origin'),
        'http://localhost:5173',
      );
      // Dox sends the allowed list, not an echo of the asked headers.
      expect(
        pre.header('access-control-allow-headers'),
        allOf(contains('authorization'), contains('x-group-id')),
      );

      TestResponse ok = await app.call(
        '/api/v1/me',
        headers: <String, String>{'origin': 'http://localhost:5173'},
      );
      expect(ok.header('access-control-allow-origin'), 'http://localhost:5173');
      TestResponse other = await app.call(
        '/api/v1/me',
        headers: <String, String>{'origin': 'http://evil.test'},
      );
      expect(other.header('access-control-allow-origin'), isNull);
    });

    test('SPA fallback, unknown API paths, and path traversal', () async {
      TestResponse page = await app.client.get('/login');
      page.expectStatus(200);
      expect(page.body, contains('spa'));
      // No other site may frame the pages (the OAuth consent page).
      expect(page.header('content-security-policy'), "frame-ancestors 'none'");
      expect(page.header('x-frame-options'), 'SAMEORIGIN');
      (await app.call('/api/v1/nope')).expectStatus(404);
      (int, String) traversal = await app.raw('GET', '/..%2f..%2fpubspec.yaml');
      expect(traversal.$1, 200); // falls back to index.html
      expect(traversal.$2, contains('spa'));
      expect(traversal.$2, isNot(contains('name: api_dox')));
    });

    test('assets are gzipped and cached forever', () async {
      String path = '/assets/app-abc123.js';
      List<int> original = await File('test/fixtures/public$path')
          .readAsBytes();
      HttpClient http = HttpClient()..autoUncompress = false;
      try {
        HttpClientRequest req = await http.getUrl(
          app.client.baseUri.resolve(path),
        );
        req.headers.set('accept-encoding', 'gzip, br');
        HttpClientResponse res = await req.close();
        List<int> body = await res.fold<List<int>>(
          <int>[],
          (List<int> all, List<int> chunk) => all..addAll(chunk),
        );
        expect(res.statusCode, 200);
        expect(res.headers.value('content-encoding'), 'gzip');
        expect(res.headers['vary']!.join(','), contains('Accept-Encoding'));
        expect(
          res.headers.value('cache-control'),
          'public, max-age=31536000, immutable',
        );
        expect(body.length, lessThan(original.length));
        // Gzipped once: one unzip gives back the file.
        expect(gzip.decode(body), original);

        // A client without gzip gets the plain file.
        HttpClientRequest plainReq = await http.getUrl(
          app.client.baseUri.resolve(path),
        );
        plainReq.headers.removeAll('accept-encoding');
        HttpClientResponse plain = await plainReq.close();
        List<int> plainBody = await plain.fold<List<int>>(
          <int>[],
          (List<int> all, List<int> chunk) => all..addAll(chunk),
        );
        expect(plain.headers.value('content-encoding'), isNull);
        expect(plainBody, original);
      } finally {
        http.close(force: true);
      }
    });
  });

  group('mcp', () {
    String verifier = 'v' * 64;
    String redirect = 'http://127.0.0.1:33418/callback';
    String challenge = base64Url
        .encode(sha256.convert(ascii.encode(verifier)).bytes)
        .replaceAll('=', '');

    Future<String> register() async {
      TestResponse res = await app.client.post(
        '/oauth/register',
        headers: <String, String>{'content-type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'client_name': 'Claude',
          'redirect_uris': <String>[redirect],
        }),
      );
      res.expectStatus(201);
      return res.json['client_id'] as String;
    }

    /// The whole sign-in, the way a client and the consent page do it.
    Future<String> signIn(String user) async {
      String clientId = await register();
      TestResponse asked = await app.call(
        '/api/v1/oauth/client?client_id=${Uri.encodeQueryComponent(clientId)}'
        '&redirect_uri=${Uri.encodeQueryComponent(redirect)}',
        user: user,
      );
      asked.expectStatus(200);
      expect(asked.json['data'], <String, dynamic>{
        'name': 'Claude',
        'redirectHost': '127.0.0.1',
        'full': false,
      });
      TestResponse yes = await app.call(
        '/api/v1/oauth/approve',
        method: 'POST',
        user: user,
        body: <String, dynamic>{
          'clientId': clientId,
          'redirectUri': redirect,
          'codeChallenge': challenge,
          'codeChallengeMethod': 'S256',
          'state': 'st',
          'resource': '${app.appUrl}/mcp',
        },
      );
      yes.expectStatus(200);
      Uri back = Uri.parse(yes.json['data']['url'] as String);
      expect(back.queryParameters['state'], 'st');
      TestResponse token = await app.client.post(
        '/oauth/token',
        headers: <String, String>{
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: Uri(
          queryParameters: <String, String>{
            'grant_type': 'authorization_code',
            'code': back.queryParameters['code']!,
            'client_id': clientId,
            'redirect_uri': redirect,
            'code_verifier': verifier,
          },
        ).query,
      );
      token.expectStatus(200);
      String access = token.json['access_token'] as String;
      expect(access, startsWith('mex_'));
      return access;
    }

    Future<int> ping(String token) async {
      TestResponse res = await app.client.post(
        '/mcp',
        headers: <String, String>{
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': <String, dynamic>{'protocolVersion': '2025-06-18'},
        }),
      );
      return res.status;
    }

    test(
      'no token: 401 that points to the sign-in; the old URL is gone',
      () async {
        TestResponse res = await app.client.post(
          '/mcp',
          headers: <String, String>{'content-type': 'application/json'},
          body: '{}',
        );
        res.expectStatus(401);
        expect(
          res.header('www-authenticate'),
          'Bearer resource_metadata="${app.appUrl}'
          '/.well-known/oauth-protected-resource/mcp"',
        );
        expect(await ping('mex_wrong'), 401);
        TestResponse meta = await app.client.get(
          '/.well-known/oauth-authorization-server',
        );
        expect(
          meta.json['authorization_endpoint'],
          '${app.appUrl}/oauth/authorize',
        );
        (await app.client.post(
          '/mcp/some-old-token',
          headers: <String, String>{'content-type': 'application/json'},
          body: '{}',
        )).expectStatus(404);
      },
    );

    test('the Me page lists the clients; remove one or all', () async {
      String first = await signIn('carol');
      String second = await signIn('carol');
      TestResponse me = await app.call('/api/v1/me/mcp', user: 'carol');
      expect(me.json['data']['url'], '${app.appUrl}/mcp');
      List<dynamic> clients = me.json['data']['clients'] as List<dynamic>;
      expect(clients, hasLength(2));
      expect(clients.first['name'], 'Claude (127.0.0.1)');
      expect(clients.first['lastUsedAt'], isNull);

      expect(await ping(first), 200);
      TestResponse used = await app.call('/api/v1/me/mcp', user: 'carol');
      expect(
        (used.json['data']['clients'] as List<dynamic>).last['lastUsedAt'],
        isA<String>(),
      );

      // another user can not remove carol's client
      int newest = clients.first['id'] as int;
      (await app.call(
        '/api/v1/me/mcp/clients/$newest',
        method: 'DELETE',
        user: 'bob',
      )).expectStatus(404);
      (await app.call(
        '/api/v1/me/mcp/clients/$newest',
        method: 'DELETE',
        user: 'carol',
      )).expectStatus(204);
      expect(await ping(second), 401);
      expect(await ping(first), 200);

      TestResponse all = await app.call(
        '/api/v1/me/mcp/rotate',
        method: 'POST',
        user: 'carol',
      );
      expect(all.json['data']['clients'], isEmpty);
      expect(await ping(first), 401);
    });

    test('the consent API refuses a wrong client or address', () async {
      String clientId = await register();
      (await app.call(
        '/api/v1/oauth/client?client_id=${Uri.encodeQueryComponent(clientId)}'
        '&redirect_uri=${Uri.encodeQueryComponent('https://evil.test/cb')}',
      )).expectStatus(422);
      (await app.call(
        '/api/v1/oauth/client?client_id=forged.sig'
        '&redirect_uri=${Uri.encodeQueryComponent(redirect)}',
      )).expectStatus(422);
      (await app.call(
        '/api/v1/oauth/approve',
        method: 'POST',
        body: <String, dynamic>{'clientId': clientId},
      )).expectStatus(422);
      TestResponse no = await app.call(
        '/api/v1/oauth/deny',
        method: 'POST',
        body: <String, dynamic>{
          'clientId': clientId,
          'redirectUri': redirect,
          'state': 'st',
        },
      );
      Uri back = Uri.parse(no.json['data']['url'] as String);
      expect(back.queryParameters['error'], 'access_denied');
      // signing in needs a Firebase user
      (await app.call('/api/v1/oauth/client', user: '')).expectStatus(401);
    });

    test('initialize, list tools, add an expense', () async {
      String mcpPath = '/mcp';
      Map<String, String> headers = <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json, text/event-stream',
        'authorization': 'Bearer ${await signIn('alice')}',
      };
      TestResponse init = await app.client.post(
        mcpPath,
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': <String, dynamic>{
            'protocolVersion': '2025-06-18',
            'capabilities': <String, dynamic>{},
            'clientInfo': <String, dynamic>{'name': 't', 'version': '1'},
          },
        }),
      );
      init.expectStatus(200);
      String sessionId = init.header('mcp-session-id') ?? '';
      expect(sessionId, isNot(''));
      expect(init.json['result']['protocolVersion'], '2025-06-18');

      Future<Map<String, dynamic>> rpc(
        int id,
        String method,
        Object? params,
      ) async {
        TestResponse res = await app.client.post(
          mcpPath,
          headers: <String, String>{
            ...headers,
            'mcp-session-id': sessionId,
            'mcp-protocol-version': '2025-06-18',
          },
          body: jsonEncode(<String, dynamic>{
            'jsonrpc': '2.0',
            'id': id,
            'method': method,
            'params': params,
          }),
        );
        String text = res.body;
        String line = text
            .split('\n')
            .firstWhere(
              (String l) => l.startsWith('data: '),
              orElse: () => 'data: $text',
            );
        return jsonDecode(line.substring(6)) as Map<String, dynamic>;
      }

      Map<String, dynamic> tools = await rpc(
        2,
        'tools/list',
        <String, dynamic>{},
      );
      List<dynamic> toolList = tools['result']['tools'] as List<dynamic>;
      expect(toolList, hasLength(44));
      // The input schema comes from the DTO, with its @Describe hints.
      Map<String, dynamic> addSchema =
          toolList.firstWhere(
                (dynamic t) => t['name'] == 'add_expense',
              )['inputSchema']
              as Map<String, dynamic>;
      expect(addSchema['properties']['groupId']['description'], isNotEmpty);
      expect(addSchema['required'], contains('categoryId'));

      Map<String, dynamic> cats = await rpc(6, 'tools/call', <String, dynamic>{
        'name': 'list_categories',
        'arguments': <String, dynamic>{'groupId': groupId},
      });
      int transportId =
          (cats['result']['structuredContent']['categories'] as List<dynamic>)
                  .firstWhere((dynamic c) => c['name'] == 'Transport')['id']
              as int;

      Map<String, dynamic> added = await rpc(3, 'tools/call', <String, dynamic>{
        'name': 'add_expense',
        'arguments': <String, dynamic>{
          'groupId': groupId,
          'categoryId': transportId,
          'amount': 7.25,
          'occurredOn': '2026-08-20',
        },
      });
      // Data comes back as serializer JSON: as text, and as structuredContent.
      Map<String, dynamic> result = added['result'] as Map<String, dynamic>;
      Map<String, dynamic> expense =
          result['structuredContent']['expense'] as Map<String, dynamic>;
      expect(result.containsKey('isError'), isFalse);
      expect(
        jsonDecode(result['content'][0]['text'] as String),
        result['structuredContent'],
      );
      expect(result['structuredContent']['currency'], 'THB');
      expect(expense['amountCents'], 725);
      expect(expense['occurredOn'], '2026-08-20');
      expect(expense['category']['name'], 'Transport');

      Map<String, dynamic> list = await rpc(4, 'tools/call', <String, dynamic>{
        'name': 'list_expenses',
        'arguments': <String, dynamic>{'groupId': groupId, 'month': '2026-08'},
      });
      Map<String, dynamic> listed =
          list['result']['structuredContent'] as Map<String, dynamic>;
      expect(listed['month'], '2026-08');
      expect(listed['expenses'], hasLength(1));
      expect(listed['expenses'][0]['id'], expense['id']);

      // A mistake the model can fix is an error result, not a crash.
      Map<String, dynamic> missing = await rpc(
        5,
        'tools/call',
        <String, dynamic>{
          'name': 'delete_expense',
          'arguments': <String, dynamic>{'groupId': groupId, 'id': 999999},
        },
      );
      expect(missing['result']['isError'], isTrue);
      expect(missing['result']['content'][0]['text'], contains('not found'));

      // Bad arguments come back from the DTO check, as an error result.
      Map<String, dynamic> bad = await rpc(7, 'tools/call', <String, dynamic>{
        'name': 'add_shopping_item',
        'arguments': <String, dynamic>{'groupId': groupId, 'name': ''},
      });
      expect(bad['result']['isError'], isTrue);
      expect(bad['result']['content'][0]['text'], contains('name'));

      // An id that HTTP takes from the URL is still needed by the tool.
      Map<String, dynamic> noId = await rpc(8, 'tools/call', <String, dynamic>{
        'name': 'update_wallet',
        'arguments': <String, dynamic>{'name': 'Cash'},
      });
      expect(noId['result']['isError'], isTrue);
      expect(
        noId['result']['content'][0]['text'],
        contains('accountId is required'),
      );
    });

    test('a session works only for its user, and is signed', () async {
      String alicePath = '/mcp';
      String bobPath = '/mcp';
      Map<String, String> headers = <String, String>{
        'content-type': 'application/json',
        'authorization': 'Bearer ${await signIn('alice')}',
      };
      Map<String, String> bob = <String, String>{
        'content-type': 'application/json',
        'authorization': 'Bearer ${await signIn('bob')}',
      };
      TestResponse init = await app.client.post(
        alicePath,
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': <String, dynamic>{'protocolVersion': '2025-06-18'},
        }),
      );
      String sessionId = init.header('mcp-session-id')!;
      String ping = jsonEncode(<String, dynamic>{
        'jsonrpc': '2.0',
        'id': 2,
        'method': 'ping',
      });

      // Alice's session with Bob's token is not found: the client starts over.
      (await app.client.post(
        bobPath,
        headers: <String, String>{...bob, 'mcp-session-id': sessionId},
        body: ping,
      )).expectStatus(404);
      (await app.client.post(
        alicePath,
        headers: <String, String>{
          ...headers,
          'mcp-session-id': '${sessionId}x',
        },
        body: ping,
      )).expectStatus(404);
      (await app.client.post(
        alicePath,
        headers: headers,
        body: ping,
      )).expectStatus(400);
      (await app.client.post(
        alicePath,
        headers: <String, String>{...headers, 'mcp-session-id': sessionId},
        body: ping,
      )).expectStatus(200).expectJson(<String, dynamic>{
        'jsonrpc': '2.0',
        'id': 2,
        'result': <String, dynamic>{},
      });

      // A notification gets 202 and no body; GET has no stream.
      (await app.client.post(
        alicePath,
        headers: <String, String>{...headers, 'mcp-session-id': sessionId},
        body: jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'method': 'notifications/initialized',
        }),
      )).expectStatus(202);
      (await app.client.get(
        alicePath,
        headers: <String, String>{...headers, 'mcp-session-id': sessionId},
      )).expectStatus(405);
      (await app.client.delete(
        alicePath,
        headers: <String, String>{...headers, 'mcp-session-id': sessionId},
      )).expectStatus(200);
    });
  });

  group('balance adjustment', () {
    test('books the difference up or down, and rejects no change', () async {
      TestResponse created = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        body: <String, dynamic>{
          'name': 'Adjust me',
          'currency': 'THB',
          'color': '#778899',
        },
      );
      int id = created.json['data']['id'] as int;
      await app.call(
        '/api/v1/accounts/$id/entries',
        method: 'POST',
        body: <String, dynamic>{'amount': 1000, 'occurredOn': '2026-11-01'},
      );
      Future<int> balance() async {
        TestResponse res = await app.call('/api/v1/accounts');
        return (res.json['data'] as List<dynamic>).firstWhere(
              (dynamic a) => a['id'] == id,
            )['balanceCents']
            as int;
      }

      // 1000 -> 1500 adds 500
      TestResponse up = await app.call(
        '/api/v1/accounts/$id/adjustments',
        method: 'POST',
        body: <String, dynamic>{'balance': 1500, 'occurredOn': '2026-11-02'},
      );
      up.expectStatus(201);
      expect(
        up.json['data'],
        matchesObject(<String, Object?>{
          'amountCents': 50000,
          'note': 'Balance adjustment',
        }),
      );
      expect(await balance(), 150000);

      // 1500 -> 500 takes 1000 out
      TestResponse down = await app.call(
        '/api/v1/accounts/$id/adjustments',
        method: 'POST',
        body: <String, dynamic>{
          'balance': 500,
          'occurredOn': '2026-11-03',
          'note': 'Counted cash',
        },
      );
      expect(
        down.json['data'],
        matchesObject(<String, Object?>{
          'amountCents': -100000,
          'note': 'Counted cash',
        }),
      );
      expect(await balance(), 50000);

      (await app.call(
        '/api/v1/accounts/$id/adjustments',
        method: 'POST',
        body: <String, dynamic>{'balance': 500, 'occurredOn': '2026-11-03'},
      )).expectStatus(422);

      // Another user's account is not found.
      (await app.call(
        '/api/v1/accounts/$id/adjustments',
        method: 'POST',
        user: 'bob',
        body: <String, dynamic>{'balance': 1, 'occurredOn': '2026-11-03'},
      )).expectStatus(404);
    });
  });

  group('frequent expenses', () {
    test(
      'repeats show up, most used first; one-offs and old ones do not',
      () async {
        String user = 'frank';
        TestResponse groups = await app.call('/api/v1/groups', user: user);
        int gid = (groups.json['data'] as List<dynamic>).first['id'] as int;
        TestResponse categories = await app.call(
          '/api/v1/categories',
          user: user,
          group: gid,
        );
        int food =
            (categories.json['data'] as List<dynamic>).first['id'] as int;
        Future<TestResponse> add(num amount, String note, String occurredOn) {
          return app.call(
            '/api/v1/expenses',
            method: 'POST',
            user: user,
            group: gid,
            body: <String, dynamic>{
              'categoryId': food,
              'amount': amount,
              'note': note,
              'occurredOn': occurredOn,
            },
          );
        }

        await add(60, 'Coffee', dayFromToday(-1));
        await add(60, 'Coffee', dayFromToday(-2));
        await add(60, 'Coffee', dayFromToday(0));
        await add(120, 'Lunch', dayFromToday(-3));
        await add(120, 'Lunch', dayFromToday(-4));
        await add(999, 'Once', dayFromToday(-1));
        await add(45, 'Old', dayFromToday(-200));
        await add(45, 'Old', dayFromToday(-201));

        TestResponse res = await app.call(
          '/api/v1/expenses/frequent',
          user: user,
          group: gid,
        );
        res.expectStatus(200);
        expect(res.json['data'], <dynamic>[
          <String, dynamic>{
            'categoryId': food,
            'amountCents': 6000,
            'note': 'Coffee',
            'uses': 3,
            'lastOn': dayFromToday(0),
          },
          <String, dynamic>{
            'categoryId': food,
            'amountCents': 12000,
            'note': 'Lunch',
            'uses': 2,
            'lastOn': dayFromToday(-3),
          },
        ]);
      },
    );
  });

  group('balance history', () {
    test('end-of-day balances for each day, ignoring future entries', () async {
      String user = 'hana';
      TestResponse created = await app.call(
        '/api/v1/accounts',
        method: 'POST',
        user: user,
        body: <String, dynamic>{
          'name': 'History',
          'currency': 'THB',
          'color': '#336699',
        },
      );
      int id = created.json['data']['id'] as int;
      Future<TestResponse> entry(num amount, String occurredOn) {
        return app.call(
          '/api/v1/accounts/$id/entries',
          method: 'POST',
          user: user,
          body: <String, dynamic>{'amount': amount, 'occurredOn': occurredOn},
        );
      }

      await entry(500, dayFromToday(-40)); // before the window
      await entry(1000, dayFromToday(-10));
      await entry(-200, dayFromToday(0));
      await entry(70, dayFromToday(3)); // future: not in the history

      TestResponse res = await app.call(
        '/api/v1/accounts/history?days=30',
        user: user,
      );
      res.expectStatus(200);
      expect(res.json['data']['from'], dayFromToday(-29));
      List<dynamic> series =
          res.json['data']['balances']['$id'] as List<dynamic>;
      expect(series, hasLength(30));
      expect(series[0], 50000);
      expect(series[18], 50000); // 11 days ago
      expect(series[19], 150000); // 10 days ago
      expect(series[29], 130000); // today

      // Bad or huge `days` is clamped, and other users' accounts never show.
      TestResponse clamped = await app.call(
        '/api/v1/accounts/history?days=9999',
        user: user,
      );
      expect(clamped.json['data']['balances']['$id'], hasLength(365));
      TestResponse other = await app.call(
        '/api/v1/accounts/history',
        user: 'bob',
      );
      expect(
        (other.json['data']['balances'] as Map<String, dynamic>).containsKey(
          '$id',
        ),
        isFalse,
      );
    });
  });

  group('shopping list', () {
    String path = '/api/v1/shopping-items';

    test(
      'add, tick, untick, rename and delete items in the group list',
      () async {
        TestResponse milk = await app.call(
          path,
          method: 'POST',
          group: groupId,
          body: <String, dynamic>{'name': '  Milk '},
        );
        milk.expectStatus(201);
        expect(
          milk.json['data'],
          matchesObject(<String, Object?>{
            'name': 'Milk',
            'done': false,
            'doneAt': null,
          }),
        );
        int milkId = milk.json['data']['id'] as int;
        TestResponse eggs = await app.call(
          path,
          method: 'POST',
          group: groupId,
          body: <String, dynamic>{'name': 'Eggs'},
        );

        TestResponse ticked = await app.call(
          '$path/$milkId',
          method: 'PATCH',
          group: groupId,
          body: <String, dynamic>{'done': true},
        );
        expect(ticked.json['data']['done'], isTrue);
        expect(ticked.json['data']['doneAt'], isA<String>());

        // Still to buy first, then bought.
        TestResponse list = await app.call(path, group: groupId);
        expect(
          <Object?>[
            for (dynamic item in list.json['data'] as List<dynamic>)
              item['name'],
          ],
          <String>['Eggs', 'Milk'],
        );

        TestResponse untick = await app.call(
          '$path/$milkId',
          method: 'PATCH',
          group: groupId,
          body: <String, dynamic>{'done': false, 'name': 'Oat milk'},
        );
        expect(
          untick.json['data'],
          matchesObject(<String, Object?>{
            'name': 'Oat milk',
            'done': false,
            'doneAt': null,
          }),
        );

        (await app.call(
          '$path/${eggs.json['data']['id']}',
          method: 'DELETE',
          group: groupId,
        )).expectStatus(204);
        TestResponse after = await app.call(path, group: groupId);
        expect(after.json['data'] as List<dynamic>, hasLength(1));
      },
    );

    test('clearing removes only bought items', () async {
      TestResponse bread = await app.call(
        path,
        method: 'POST',
        group: groupId,
        body: <String, dynamic>{'name': 'Bread'},
      );
      await app.call(
        '$path/${bread.json['data']['id']}',
        method: 'PATCH',
        group: groupId,
        body: <String, dynamic>{'done': true},
      );
      TestResponse cleared = await app.call(
        '$path/done',
        method: 'DELETE',
        group: groupId,
      );
      expect(cleared.json['data'], <String, dynamic>{'deleted': 1});
      TestResponse list = await app.call(path, group: groupId);
      expect(
        <Object?>[
          for (dynamic item in list.json['data'] as List<dynamic>) item['name'],
        ],
        <String>['Oat milk'],
      );
    });

    test(
      'empty names are rejected and other groups cannot see or touch items',
      () async {
        (await app.call(
          path,
          method: 'POST',
          group: groupId,
          body: <String, dynamic>{'name': ' '},
        )).expectStatus(422);
        TestResponse list = await app.call(path, group: groupId);
        int itemId = (list.json['data'] as List<dynamic>).first['id'] as int;
        // Carol has her own group and is not a member of this one.
        await app.call('/api/v1/me', user: 'carol');
        (await app.call(path, user: 'carol', group: groupId)).expectStatus(404);
        (await app.call(
          '$path/$itemId',
          method: 'DELETE',
          user: 'carol',
          group: groupId,
        )).expectStatus(404);
      },
    );
  });
}
