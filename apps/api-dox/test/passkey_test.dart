import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dox_core/testing.dart';
import 'package:pointycastle/export.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// A passkey on a fake device: a real P-256 key, real signatures.
class FakeAuthenticator {
  FakeAuthenticator(this.origin) {
    ECKeyGenerator generator = ECKeyGenerator()
      ..init(
        ParametersWithRandom<ECKeyGeneratorParameters>(
          ECKeyGeneratorParameters(ECCurve_secp256r1()),
          _random(),
        ),
      );
    AsymmetricKeyPair<PublicKey, PrivateKey> pair = generator.generateKeyPair();
    _private = pair.privateKey as ECPrivateKey;
    Uint8List point = (pair.publicKey as ECPublicKey).Q!.getEncoded(false);
    spki = Uint8List.fromList(<int>[..._hex(_spkiHeader), ...point]);
  }

  final String origin;
  final String credentialId = b64(
    utf8.encode('cred-${Random().nextInt(1 << 30)}'),
  );
  late final ECPrivateKey _private;
  late final Uint8List spki;
  int counter = 0;

  static const String _spkiHeader =
      '3059301306072a8648ce3d020106082a8648ce3d030107034200';

  Map<String, Object> create(String challenge) {
    return <String, Object>{
      'credentialId': credentialId,
      'clientDataJson': _clientData('webauthn.create', challenge),
      'authenticatorData': b64(_authData()),
      'publicKey': b64(spki),
      'publicKeyAlgorithm': -7,
      'name': 'Test phone',
    };
  }

  Map<String, Object> get(String challenge, {String? asOrigin}) {
    String clientData = _clientData('webauthn.get', challenge, asOrigin);
    Uint8List auth = _authData();
    Uint8List message = Uint8List.fromList(<int>[
      ...auth,
      ...SHA256Digest().process(
        base64Url.decode(base64Url.normalize(clientData)),
      ),
    ]);
    ECDSASigner signer = ECDSASigner(SHA256Digest())
      ..init(
        true,
        ParametersWithRandom<PrivateKeyParameter<ECPrivateKey>>(
          PrivateKeyParameter<ECPrivateKey>(_private),
          _random(),
        ),
      );
    ECSignature sig = signer.generateSignature(message) as ECSignature;
    return <String, Object>{
      'credentialId': credentialId,
      'clientDataJson': clientData,
      'authenticatorData': b64(auth),
      'signature': b64(_der(sig.r, sig.s)),
    };
  }

  String _clientData(String type, String challenge, [String? asOrigin]) {
    return b64(
      utf8.encode(
        jsonEncode(<String, String>{
          'type': type,
          'challenge': challenge,
          'origin': asOrigin ?? origin,
        }),
      ),
    );
  }

  /// rpIdHash, flags (user present + verified), counter.
  Uint8List _authData() {
    counter++;
    Uint8List rpIdHash = SHA256Digest().process(
      Uint8List.fromList(utf8.encode(Uri.parse(origin).host)),
    );
    ByteData count = ByteData(4)..setUint32(0, counter);
    return Uint8List.fromList(<int>[
      ...rpIdHash,
      0x05,
      ...count.buffer.asUint8List(),
    ]);
  }

  static Uint8List _der(BigInt r, BigInt s) {
    List<int> integer(BigInt v) {
      List<int> bytes = <int>[];
      while (v > BigInt.zero) {
        bytes.insert(0, (v & BigInt.from(0xff)).toInt());
        v = v >> 8;
      }
      if (bytes.isEmpty || bytes.first & 0x80 != 0) bytes.insert(0, 0);
      return <int>[0x02, bytes.length, ...bytes];
    }

    List<int> body = <int>[...integer(r), ...integer(s)];
    return Uint8List.fromList(<int>[0x30, body.length, ...body]);
  }

  static SecureRandom _random() {
    Random seed = Random.secure();
    return FortunaRandom()..seed(
      KeyParameter(
        Uint8List.fromList(<int>[
          for (int i = 0; i < 32; i++) seed.nextInt(256),
        ]),
      ),
    );
  }

  static Uint8List _hex(String hex) => Uint8List.fromList(<int>[
    for (int i = 0; i < hex.length; i += 2)
      int.parse(hex.substring(i, i + 2), radix: 16),
  ]);
}

String b64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

void main() {
  late TestApp app;
  late FakeAuthenticator device;

  setUpAll(() async {
    app = await TestApp.start();
    device = FakeAuthenticator(Uri.parse(app.appUrl).origin);
  });

  tearDownAll(() async {
    await app.close();
  });

  Future<String> challenge(String path, {String user = 'alice'}) async {
    TestResponse res = await app.call(path, method: 'POST', user: user);
    res.expectStatus(200);
    return (res.json['data'] as Map<String, dynamic>)['challenge'] as String;
  }

  test('add a passkey, then sign in with it', () async {
    await app.call('/api/v1/me'); // makes alice

    String c1 = await challenge('/api/v1/me/passkeys/options');
    (await app.call(
      '/api/v1/me/passkeys',
      method: 'POST',
      body: device.create(c1),
    )).expectStatus(204);

    TestResponse list = await app.call('/api/v1/me/passkeys');
    List<dynamic> keys = list.json['data'] as List<dynamic>;
    expect(keys, hasLength(1));
    expect(keys.first, matchesObject(<String, Object?>{'name': 'Test phone'}));
    expect(
      (keys.first as Map<String, dynamic>).containsKey('publicKey'),
      isFalse,
    );

    String c2 = await challenge('/api/v1/passkeys/login/options', user: '');
    Map<String, Object> answer = device.get(c2);
    TestResponse login = await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: answer,
      user: '',
    );
    String token = login.expectStatus(200).json['data']['token'] as String;
    expect(token, startsWith('oat_'));
    TestResponse me = await app.call('/api/v1/me', token: token);
    expect(me.expectStatus(200).json['data']['email'], 'alice@gmail.com');

    // a challenge works once
    (await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: answer,
      user: '',
    )).expectStatus(401);
  });

  test('a challenge that the API did not give is refused', () async {
    (await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: device.get(b64(utf8.encode('made-up'))),
      user: '',
    )).expectStatus(401);
  });

  test('an answer from another site is refused', () async {
    String c = await challenge('/api/v1/passkeys/login/options', user: '');
    (await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: device.get(c, asOrigin: 'https://evil.example.com'),
      user: '',
    )).expectStatus(401);
  });

  test('a wrong signature is refused', () async {
    String c = await challenge('/api/v1/passkeys/login/options', user: '');
    Map<String, Object> answer = device.get(c);
    Map<String, Object> other = FakeAuthenticator(device.origin).get(c);
    answer['signature'] = other['signature']!;
    (await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: answer,
      user: '',
    )).expectStatus(401);
  });

  test('another user cannot use my registration challenge', () async {
    String c = await challenge('/api/v1/me/passkeys/options');
    FakeAuthenticator bobDevice = FakeAuthenticator(device.origin);
    (await app.call(
      '/api/v1/me/passkeys',
      method: 'POST',
      body: bobDevice.create(c),
      user: 'bob',
    )).expectStatus(422);
  });

  test('a removed passkey cannot sign in', () async {
    TestResponse list = await app.call('/api/v1/me/passkeys');
    int id =
        ((list.json['data'] as List<dynamic>).first
                as Map<String, dynamic>)['id']
            as int;
    (await app.call(
      '/api/v1/me/passkeys/$id',
      method: 'DELETE',
    )).expectStatus(204);
    (await app.call(
      '/api/v1/me/passkeys/$id',
      method: 'DELETE',
    )).expectStatus(404);

    String c = await challenge('/api/v1/passkeys/login/options', user: '');
    (await app.call(
      '/api/v1/passkeys/login',
      method: 'POST',
      body: device.get(c),
      user: '',
    )).expectStatus(401);
  });
}
