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

      TestResponse enable = await post('enable', 'tina', codeNow(secret, 1));
      enable.expectStatus(200).expectJson(<String, dynamic>{
        'data': <String, dynamic>{'token': 'mfa:tina'},
      });

      // step one alone is stopped: 403, not 401 (a 401 logs the app out)
      (await app.call('/api/v1/me', user: 'tina')).expectStatus(403).expectJson(
        <String, dynamic>{
          'message': 'Two-step code needed',
          'code': 'mfa_required',
        },
      );
      (await app.call('/api/v1/groups', user: 'tina')).expectStatus(403);
      (await post('setup', 'tina')).expectStatus(403);
      (await app.call(
        '/api/v1/me/totp',
        method: 'DELETE',
        user: 'tina',
      )).expectStatus(403);

      // the code gives the token that passes
      String code = codeNow(secret);
      (await post('verify', 'tina', code)).expectStatus(200).expectJson(
        <String, dynamic>{
          'data': <String, dynamic>{'token': 'mfa:tina'},
        },
      );
      TestResponse me = await app.call('/api/v1/me', user: 'mfa:tina');
      expect(me.expectStatus(200).json['data']['twoFactorEnabled'], isTrue);

      // a code works once
      (await post('verify', 'tina', code)).expectStatus(422);

      // turn off: step one is enough again
      (await app.call(
        '/api/v1/me/totp',
        method: 'DELETE',
        user: 'mfa:tina',
      )).expectStatus(204);
      TestResponse after = await app.call('/api/v1/me', user: 'tina');
      expect(after.expectStatus(200).json['data']['twoFactorEnabled'], isFalse);
    });

    test('code tries are limited', () async {
      String secret =
          (await post('setup', 'gus')).json['data']['secret'] as String;
      (await post('enable', 'gus', codeNow(secret))).expectStatus(200);
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
