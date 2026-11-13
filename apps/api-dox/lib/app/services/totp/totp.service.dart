import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/api_token.service.dart';
import 'package:api_dox/app/services/totp/totp.dart';
import 'package:api_dox/config/env.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_auth/dox_auth.dart';
import 'package:dox_core/dox_core.dart';

/// Two-step sign-in with an authenticator app.
///
/// Firebase still does step one (Google, or email and password). The API
/// token of that sign-in is not marked, so `TwoFactorMiddleware` stops it.
/// The user then sends a code to [verify], which marks that token.
@Inject()
class TotpService {
  TotpService(this.users, this.tokens);

  final UserRepository users;
  final ApiTokenService tokens;

  /// Step 1 of turning it on: a new secret, not active yet.
  Future<Map<String, String>> setup(User user) async {
    _mustBeOff(user);
    String secret = Totp.newSecret();
    await users.update(user.id!, <String, dynamic>{
      'totp_secret': AESEncryptor.encode(secret, env.appKey, purpose: _purpose),
      'totp_enabled': false,
    });
    return <String, String>{
      'secret': secret,
      'uri': Totp.uri(secret, account: user.email, issuer: totpIssuer),
    };
  }

  /// Step 2: one right code proves the app has the secret. Marks [token],
  /// so this browser stays signed in. Other browsers are asked for a code.
  Future<void> enable(User user, AccessToken token, String code) async {
    _mustBeOff(user);
    await _check(user, code);
    await users.update(user.id!, <String, dynamic>{'totp_enabled': true});
    await tokens.markSecondFactor(token);
  }

  /// The second step of a sign-in: marks [token].
  Future<void> verify(User user, AccessToken token, String code) async {
    if (user.totpEnabled != true) {
      throw HttpError.unprocessable('Two-step sign-in is off');
    }
    await _check(user, code);
    await tokens.markSecondFactor(token);
  }

  Future<void> disable(User user) async {
    await users.update(user.id!, <String, dynamic>{
      'totp_secret': null,
      'totp_enabled': false,
    });
  }

  static void _mustBeOff(User user) {
    if (user.totpEnabled == true) {
      throw HttpError.unprocessable('Two-step sign-in is already on');
    }
  }

  Future<void> _check(User user, String code) async {
    String? sealed = user.totpSecret;
    if (sealed == null) {
      throw HttpError.unprocessable('Start the setup first');
    }
    String secret = AESEncryptor.decode(sealed, env.appKey, purpose: _purpose);
    // A code works once, so one that was seen over the shoulder is no use.
    String usedKey = 'totp:used:${user.id}:$code';
    if (!Totp.check(secret, code) || await Cache().has(usedKey)) {
      throw HttpError.unprocessable('Wrong code. Try again.');
    }
    await Cache().put(usedKey, '1', duration: totpCodeLife);
  }

  /// The AES key is made from `APP_KEY` and this label.
  static const String _purpose = 'totp';
}
