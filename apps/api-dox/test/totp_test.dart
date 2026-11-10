import 'package:api_dox/app/services/totp/totp.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Two-step sign-in with an authenticator app.
void main() {
  group('Totp', () {
    // RFC 6238, appendix B (SHA-1): the last 6 digits of the 8-digit codes.
    const String rfcSecret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';

    test('gives the codes of the RFC', () {
      expect(Totp.codeAt(rfcSecret, 59 ~/ 30), '287082');
      expect(Totp.codeAt(rfcSecret, 1111111109 ~/ 30), '081804');
      expect(Totp.codeAt(rfcSecret, 2000000000 ~/ 30), '279037');
    });

    test('takes a code one step off, not two', () {
      DateTime at(int seconds) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }

      expect(Totp.check(rfcSecret, '287082', now: at(59)), isTrue);
      expect(Totp.check(rfcSecret, '287082', now: at(59 + 30)), isTrue);
      expect(Totp.check(rfcSecret, '287082', now: at(59 + 60)), isFalse);
      expect(Totp.check(rfcSecret, '28708', now: at(59)), isFalse);
    });
  });

  group('two-step sign-in', () {
    late TestApp app;

    setUpAll(() async {
      app = await TestApp.start();
    });

    tearDownAll(() async {
      await app.close();
    });

    Future<TestResponse> post(String path, String user, [String? code]) {
      return app.call(
        '/api/v1/me/totp/$path',
        method: 'POST',
        user: user,
        body: code == null ? null : <String, String>{'code': code},
      );
    }

    String codeNow(String secret, [int stepsAgo = 0]) {
      int counter = DateTime.now().millisecondsSinceEpoch ~/ 30000;
      return Totp.codeAt(secret, counter - stepsAgo);
    }

    test('turn on, then the API wants the code at each sign-in', () async {
      TestResponse setup = (await post('setup', 'tina')).expectStatus(200);
      String secret = setup.json['data']['secret'] as String;
      expect(
        setup.json['data']['uri'],
        'otpauth://totp/Monthly%20Expense%3Atina%40gmail.com'
        '?secret=$secret&issuer=Monthly%20Expense',
      );

      // not on until one code is proven
      (await post('enable', 'tina', '000000')).expectStatus(422);
      (await app.call('/api/v1/me', user: 'tina')).expectStatus(200);

      (await post('enable', 'tina', codeNow(secret, 1))).expectStatus(204);
      // the browser that turned it on stays signed in
      (await app.call('/api/v1/me', user: 'tina')).expectStatus(200);

      // a new sign-in is stopped: 403, not 401 (a 401 logs the app out)
      String fresh = await app.signIn('tina');
      Future<TestResponse> asFresh(String path, [String method = 'GET']) {
        return app.call('/api/v1$path', method: method, token: fresh);
      }

      (await asFresh('/me')).expectStatus(403).expectJson(<String, dynamic>{
        'message': 'Two-step code needed',
        'code': 'mfa_required',
      });
      (await asFresh('/groups')).expectStatus(403);
      (await asFresh('/me/totp/setup', 'POST')).expectStatus(403);
      (await asFresh('/me/totp', 'DELETE')).expectStatus(403);

      // the code lets this sign-in through
      String code = codeNow(secret);
      (await app.call(
        '/api/v1/me/totp/verify',
        method: 'POST',
        token: fresh,
        body: <String, String>{'code': code},
      )).expectStatus(204);
      TestResponse me = await asFresh('/me');
      expect(me.expectStatus(200).json['data']['twoFactorEnabled'], isTrue);

      // a code works once
      (await app.call(
        '/api/v1/me/totp/verify',
        method: 'POST',
        token: fresh,
        body: <String, String>{'code': code},
      )).expectStatus(422);

      // a refresh keeps the mark
      TestResponse refreshed = await app.call(
        '/api/v1/auth/token/refresh',
        method: 'POST',
        token: fresh,
      );
      String renewed =
          refreshed.expectStatus(200).json['data']['token'] as String;
      (await app.call('/api/v1/me', token: renewed)).expectStatus(200);

      // a Firebase session that has the `mfa` claim passes at sign-in
      (await app.call('/api/v1/me', user: 'mfa:tina')).expectStatus(200);

      // turn off: step one is enough again
      (await asFresh('/me/totp', 'DELETE')).expectStatus(204);
      String later = await app.signIn('tina');
      TestResponse after = await app.call('/api/v1/me', token: later);
      expect(after.expectStatus(200).json['data']['twoFactorEnabled'], isFalse);
    });

    test('code tries are limited', () async {
      String secret =
          (await post('setup', 'gus')).json['data']['secret'] as String;
      (await post('enable', 'gus', codeNow(secret))).expectStatus(204);
      // 10 tries: more than the limit, also when a new minute starts between
      List<int> statuses = <int>[
        for (int i = 0; i < 10; i++)
          (await post('verify', 'gus', '000000')).status,
      ];
      expect(statuses, contains(429));
      expect(statuses.first, 422);
    });
  });
}
