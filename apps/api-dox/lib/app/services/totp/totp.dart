import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// TOTP (RFC 6238): the 6-digit codes of an authenticator app. SHA-1,
/// 30 seconds, 6 digits: the only kind every app reads.
class Totp {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  static const int _stepSeconds = 30;
  static final Random _random = Random.secure();

  /// A new secret: 32 base32 letters (160 bits), ready to show the user.
  static String newSecret() {
    return <String>[for (int i = 0; i < 32; i++) _alphabet[_random.nextInt(32)]]
        .join();
  }

  /// What the QR code holds. The authenticator app reads it.
  static String uri(
    String secret, {
    required String account,
    required String issuer,
  }) {
    String label = Uri.encodeComponent('$issuer:$account');
    return 'otpauth://totp/$label?secret=$secret'
        '&issuer=${Uri.encodeComponent(issuer)}';
  }

  /// True when [code] is right for now. One step before and after also
  /// pass, for a phone clock that is a little off.
  static bool check(String secret, String code, {DateTime? now}) {
    DateTime time = now ?? DateTime.now();
    int counter = time.millisecondsSinceEpoch ~/ 1000 ~/ _stepSeconds;
    bool ok = false;
    for (int drift = -1; drift <= 1; drift++) {
      // no early exit: the time must not tell which step matched
      if (_same(codeAt(secret, counter + drift), code)) ok = true;
    }
    return ok;
  }

  /// The code of one 30-second step (RFC 4226).
  static String codeAt(String secret, int counter) {
    Uint8List message = Uint8List(8)..buffer.asByteData().setUint64(0, counter);
    List<int> mac = Hmac(sha1, _base32Decode(secret)).convert(message).bytes;
    int offset = mac[mac.length - 1] & 0x0f;
    int number =
        ((mac[offset] & 0x7f) << 24) |
        (mac[offset + 1] << 16) |
        (mac[offset + 2] << 8) |
        mac[offset + 3];
    return (number % 1000000).toString().padLeft(6, '0');
  }

  static List<int> _base32Decode(String text) {
    List<int> bytes = <int>[];
    int buffer = 0;
    int bits = 0;
    for (int i = 0; i < text.length; i++) {
      int value = _alphabet.indexOf(text[i]);
      if (value < 0) throw FormatException('Not base32: $text');
      buffer = (buffer << 5) | value;
      bits += 5;
      if (bits >= 8) {
        bits -= 8;
        bytes.add((buffer >> bits) & 0xff);
      }
    }
    return bytes;
  }

  static bool _same(String a, String b) {
    if (a.length != b.length) return false;
    int diff = 0;
    for (int i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
