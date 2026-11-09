import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// A passkey response is wrong. The text is safe to show.
class WebAuthnException implements Exception {
  const WebAuthnException(this.reason);

  final String reason;

  @override
  String toString() => 'WebAuthnException: $reason';
}

/// What the browser said in `clientDataJSON` and `authenticatorData`, after
/// the checks.
class WebAuthnClientData {
  const WebAuthnClientData({required this.challenge, required this.signCount});

  final String challenge;
  final int signCount;
}

/// The checks of the WebAuthn spec that a "none" attestation needs, for
/// ES256 (P-256) keys only. No I/O: the caller checks the challenge.
///
/// ponytail: ES256 only. Every passkey provider (Apple, Google, Windows,
/// password managers) supports it. Add RS256 (-257) if a device needs it.
class WebAuthn {
  const WebAuthn(this.origins);

  /// Origins the web app runs on, like `https://app.example.com`.
  final List<String> origins;

  /// COSE id of ES256.
  static const int es256 = -7;

  /// DER header of a P-256 SubjectPublicKeyInfo. The 65-byte point follows.
  static final Uint8List _p256SpkiHeader = _hex(
    '3059301306072a8648ce3d020106082a8648ce3d030107034200',
  );

  static const int _flagUserPresent = 0x01;
  static const int _flagUserVerified = 0x04;

  /// Checks a `navigator.credentials.create()` answer.
  WebAuthnClientData checkRegistration({
    required String clientDataJson,
    required String authenticatorData,
    required String publicKey,
    required int publicKeyAlgorithm,
  }) {
    if (publicKeyAlgorithm != es256) {
      throw const WebAuthnException('This passkey type is not supported');
    }
    _point(decode(publicKey));
    return _check(clientDataJson, authenticatorData, 'webauthn.create');
  }

  /// Checks a `navigator.credentials.get()` answer against the stored
  /// [publicKey].
  WebAuthnClientData checkAssertion({
    required String clientDataJson,
    required String authenticatorData,
    required String signature,
    required String publicKey,
  }) {
    WebAuthnClientData data = _check(
      clientDataJson,
      authenticatorData,
      'webauthn.get',
    );
    Uint8List clientHash = _sha256(decode(clientDataJson));
    Uint8List signed = Uint8List.fromList(<int>[
      ...decode(authenticatorData),
      ...clientHash,
    ]);
    if (!_verify(decode(publicKey), signed, decode(signature))) {
      throw const WebAuthnException('Passkey signature is wrong');
    }
    return data;
  }

  WebAuthnClientData _check(
    String clientDataJson,
    String authenticatorData,
    String type,
  ) {
    Map<String, dynamic> client;
    try {
      client = jsonDecode(
        utf8.decode(decode(clientDataJson)),
      ) as Map<String, dynamic>;
    } catch (_) {
      throw const WebAuthnException('Passkey answer is not valid');
    }
    if (client['type'] != type) {
      throw const WebAuthnException('Passkey answer has the wrong type');
    }
    Object? origin = client['origin'];
    if (origin is! String || !origins.contains(origin)) {
      throw const WebAuthnException('Passkey answer is from another site');
    }
    Object? challenge = client['challenge'];
    if (challenge is! String || challenge.isEmpty) {
      throw const WebAuthnException('Passkey answer has no challenge');
    }

    Uint8List auth = decode(authenticatorData);
    if (auth.length < 37) {
      throw const WebAuthnException('Passkey answer is not valid');
    }
    // The rpId is the host of the page (the web app leaves `rp.id` out).
    Uint8List rpIdHash = _sha256(utf8.encode(Uri.parse(origin).host));
    for (int i = 0; i < 32; i++) {
      if (auth[i] != rpIdHash[i]) {
        throw const WebAuthnException('Passkey is for another site');
      }
    }
    int flags = auth[32];
    if (flags & _flagUserPresent == 0 || flags & _flagUserVerified == 0) {
      throw const WebAuthnException('Passkey did not check the user');
    }
    int signCount = ByteData.sublistView(auth, 33, 37).getUint32(0);
    return WebAuthnClientData(challenge: challenge, signCount: signCount);
  }

  static bool _verify(Uint8List spki, Uint8List message, Uint8List der) {
    ECDomainParameters curve = ECCurve_secp256r1();
    ECPoint? q = curve.curve.decodePoint(_point(spki));
    if (q == null) return false;
    (BigInt, BigInt)? rs = _derSignature(der);
    if (rs == null) return false;
    ECDSASigner signer = ECDSASigner(SHA256Digest())
      ..init(false, PublicKeyParameter<ECPublicKey>(ECPublicKey(q, curve)));
    try {
      return signer.verifySignature(message, ECSignature(rs.$1, rs.$2));
    } catch (_) {
      return false;
    }
  }

  /// The 65-byte point of a P-256 SubjectPublicKeyInfo.
  static Uint8List _point(Uint8List spki) {
    bool ok = spki.length == _p256SpkiHeader.length + 65;
    for (int i = 0; ok && i < _p256SpkiHeader.length; i++) {
      ok = spki[i] == _p256SpkiHeader[i];
    }
    if (!ok) throw const WebAuthnException('Passkey key is not valid');
    return Uint8List.sublistView(spki, _p256SpkiHeader.length);
  }

  /// `SEQUENCE { INTEGER r, INTEGER s }`, short lengths only (P-256 fits).
  static (BigInt, BigInt)? _derSignature(Uint8List der) {
    if (der.length < 8 || der[0] != 0x30 || der[1] != der.length - 2) {
      return null;
    }
    int at = 2;
    List<BigInt> values = <BigInt>[];
    for (int n = 0; n < 2; n++) {
      if (at + 2 > der.length || der[at] != 0x02) return null;
      int length = der[at + 1];
      at += 2;
      if (length == 0 || at + length > der.length) return null;
      BigInt value = BigInt.zero;
      for (int i = at; i < at + length; i++) {
        value = (value << 8) | BigInt.from(der[i]);
      }
      values.add(value);
      at += length;
    }
    if (at != der.length) return null;
    return (values[0], values[1]);
  }

  /// base64url, with or without `=` padding.
  static Uint8List decode(String value) {
    try {
      return base64Url.decode(base64Url.normalize(value));
    } on FormatException {
      throw const WebAuthnException('Passkey answer is not valid');
    }
  }

  static Uint8List _sha256(List<int> bytes) {
    return SHA256Digest().process(Uint8List.fromList(bytes));
  }

  static Uint8List _hex(String hex) {
    return Uint8List.fromList(<int>[
      for (int i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ]);
  }
}
