import 'dart:async';
import 'dart:io';

import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/fx/http_fetch.dart';
import 'package:api_dox/config/app.dart';
import 'package:api_dox/config/database.dart';
import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/db/migrate.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:dox_orm/dox_orm.dart';
import 'package:test/test.dart';

import '../../db/migration/migrations.dart';

/// Accepts the ID token `<uid>` and signs in `<uid>@gmail.com`. `bad` is a
/// bad token; `down` acts like Firebase timing out. `mfa:<uid>` is `<uid>`
/// with the `mfa` claim (a Firebase session from a passkey or a code).
class FakeFirebaseService extends FirebaseService {
  FakeFirebaseService() : super(const AppSettings.of());

  @override
  Future<FirebaseIdentity> verifyIdToken(String token) async {
    if (token == 'bad') throw const InvalidIdTokenException('bad token');
    if (token == 'down') throw TimeoutException('no answer');
    bool secondFactor = token.startsWith('mfa:');
    String uid = secondFactor ? token.substring(4) : token;
    return FirebaseIdentity(
      uid: uid,
      email: '$uid@gmail.com',
      name: 'Test $uid',
      secondFactor: secondFactor,
    );
  }

  @override
  void warmUp() {}
}

/// Answers rate requests from a map, and counts them. No network in tests.
class FakeHttpFetch extends HttpFetch {
  /// URL prefix -> JSON body. A missing prefix is a failed fetch.
  final Map<String, Object?> answers = <String, Object?>{};
  int calls = 0;
  String? lastPrompt;

  @override
  Future<Object?> getJson(
    String url, {
    Duration timeout = fxFetchTimeout,
  }) async {
    calls++;
    for (MapEntry<String, Object?> answer in answers.entries) {
      if (url.startsWith(answer.key)) return answer.value;
    }
    return null;
  }
}

/// Claude with a set answer, and counts the calls. Off by default, so no
/// test calls the real API, even when `.env` has a key.
class FakeClaudeClient extends ClaudeClient {
  FakeClaudeClient() : super(const AppSettings.of());

  bool on = false;
  Object? answer;
  int calls = 0;
  String? lastPrompt;

  @override
  bool get enabled => on;

  @override
  Future<Object?> askJson({
    required String system,
    required String prompt,
    required Map<String, Object?> schema,
  }) async {
    calls++;
    lastPrompt = prompt;
    return answer;
  }
}

/// The app on a real HTTP server, with an empty database.
///
/// The database is the one of `.env.testing` (a SQLite file), or Postgres
/// when `DATABASE_URL=postgres://...` is set. Its tables are wiped first.
/// Firebase and the rate providers are fakes.
class TestApp {
  TestApp._(this.client, this.fetch);

  final DoxTestClient client;
  final FakeHttpFetch fetch;

  /// `APP_URL` of the test env: the OAuth issuer and the MCP host.
  String get appUrl => Dox().ioc.get<AppSettings>().appUrl;

  /// [reset] false keeps the database as it is (it is still migrated).
  static Future<TestApp> start({bool reset = true}) async {
    Dox().initialize(appConfig);
    if (reset) {
      await resetDatabase();
    } else {
      await DbMigrator(migrations).run();
    }
    FakeHttpFetch fetch = FakeHttpFetch();
    Dox().ioc.override<FirebaseService>(FakeFirebaseService());
    Dox().ioc.override<HttpFetch>(fetch);
    Dox().ioc.override<ClaudeClient>(FakeClaudeClient());
    DoxTestClient client = await DoxTestClient.start(appConfig);
    return TestApp._(client, fetch);
  }

  Future<void> close() async {
    await client.close();
    Dox().ioc.clearOverrides();
  }

  /// API tokens by fake Firebase ID token, one sign-in each.
  final Map<String, String> _tokens = <String, String>{};

  /// A new sign-in: trades the fake Firebase ID token [user] for an API
  /// token, like the web app does.
  Future<String> signIn(String user) async {
    TestResponse res = await client.send(
      'POST',
      '/api/v1/auth/token',
      headers: <String, String>{'authorization': 'Bearer $user'},
    );
    res.expectStatus(200);
    return res.json['data']['token'] as String;
  }

  /// The API token of [user], signed in on first use.
  Future<String> tokenOf(String user) async {
    return _tokens[user] ??= await signIn(user);
  }

  /// One API call as [user] (`''`: no token), a fake Firebase ID token that
  /// is signed in on first use. [token] sends that bearer token instead.
  /// [group] sends `X-Group-Id`.
  Future<TestResponse> call(
    String path, {
    String method = 'GET',
    Object? body,
    String user = 'alice',
    String? token,
    int? group,
    Map<String, String> headers = const <String, String>{},
  }) async {
    String? bearer = token ?? (user.isEmpty ? null : await tokenOf(user));
    return client.send(
      method,
      path,
      body: body,
      headers: <String, String>{
        if (bearer != null) 'authorization': 'Bearer $bearer',
        if (group != null) 'x-group-id': '$group',
        ...headers,
      },
    );
  }

  /// A raw request, for paths the URL parser would clean up.
  Future<(int, String)> raw(String method, String rawPath) async {
    Socket socket = await Socket.connect(
      client.baseUri.host,
      client.baseUri.port,
    );
    socket.write(
      '$method $rawPath HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n',
    );
    await socket.flush();
    String text = String.fromCharCodes(
      await socket.fold<List<int>>(<int>[], (List<int> all, List<int> chunk) {
        return all..addAll(chunk);
      }),
    );
    await socket.close();
    int status = int.parse(text.split(' ')[1]);
    int split = text.indexOf('\r\n\r\n');
    return (status, split < 0 ? '' : text.substring(split + 4));
  }
}

/// True when the tests run on Postgres.
bool get onPostgres => settings.databaseClient == DatabaseClient.postgres;

/// An empty, migrated database.
Future<void> resetDatabase() async {
  if (onPostgres) {
    DBDriver driver = databaseConfig.getConnectionConfig().createDriver();
    try {
      await driver.execute('DROP SCHEMA public CASCADE');
      await driver.execute('CREATE SCHEMA public');
    } finally {
      await driver.close();
    }
  } else {
    for (String suffix in <String>['', '-wal', '-shm']) {
      File file = File('${settings.sqlitePath}$suffix');
      if (file.existsSync()) file.deleteSync();
    }
  }
  await DbMigrator(migrations).run();
}

/// `YYYY-MM-DD` for today plus [days] (UTC, like the server).
String dayFromToday(int days) {
  DateTime now = DateTime.now().toUtc();
  DateTime date = DateTime.utc(now.year, now.month, now.day + days);
  return date.toIso8601String().substring(0, 10);
}

/// `expect(actual, containsAll(expected))` for maps: every key of
/// [expected] has the same value in [actual], like Jest's `toMatchObject`.
Matcher matchesObject(Map<String, Object?> expected) {
  return allOf(<Matcher>[
    for (MapEntry<String, Object?> e in expected.entries)
      containsPair(e.key, e.value),
  ]);
}
