import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_auth/dox_auth.dart';
import 'package:dox_core/dox_core.dart';

/// A signed-in browser: the user, and the token row it sent.
class ApiSession {
  const ApiSession(this.user, this.token);

  final User user;
  final AccessToken token;

  /// This sign-in gave the two-step code, or used a passkey.
  bool get secondFactor => token.can(secondFactorAbility);
}

/// The web app's tokens: dox_auth access tokens (`AccessTokenAuthDriver`,
/// table `auth_access_tokens`). Firebase is checked once, at sign-in
/// ([signIn]), and never again: each call costs one lookup, and the app
/// trades its token for a new one before it ends ([refresh]). Only a
/// SHA-256 is stored, so a row can be deleted to sign that browser out.
@Inject()
class ApiTokenService {
  ApiTokenService(this.userService, this.firebase);

  final UserService userService;
  final FirebaseService firebase;

  /// A new one per call: an `Auth` keeps the user it checked.
  Auth get _auth => Auth(guard: apiGuard);

  /// Trades a Firebase ID token for an API token. The `mfa` claim of the
  /// ID token (a Firebase session from before these tokens) counts as the
  /// second step.
  Future<(String, User)> signIn(String idToken, {String? device}) async {
    FirebaseIdentity identity;
    try {
      identity = await firebase.verifyIdToken(idToken);
    } on InvalidIdTokenException catch (error) {
      Logger.warn('[auth] Firebase verifyIdToken failed: $error');
      throw HttpError.unauthorized('Invalid Firebase ID token');
    } catch (error) {
      // Not a 401: the web app logs the user out on every 401.
      Logger.danger('[auth] Firebase is not reachable: $error');
      throw HttpError(503, 'Sign-in check is not available. Try again.');
    }
    if (!userService.isEmailAllowed(identity.email)) {
      throw HttpError.unauthorized('This email is not allowed');
    }
    User user;
    try {
      user = await userService.findOrCreate(identity);
    } catch (error, stack) {
      Logger.danger('[auth] findOrCreate failed: $error\n$stack');
      // the error text can hold SQL; it is in the log above
      throw HttpError(500, 'User setup failed');
    }
    String token = await issue(
      user,
      secondFactor: identity.secondFactor,
      device: device,
    );
    return (token, user);
  }

  /// A new token for [user]. Also clears the expired ones.
  Future<String> issue(
    User user, {
    required bool secondFactor,
    String? device,
  }) async {
    await _auth.pruneExpiredAccessTokens();
    AccessToken token = await _auth.createAccessToken(
      user,
      name: _deviceName(device),
      abilities: <String>[if (secondFactor) secondFactorAbility],
    );
    return token.value!;
  }

  /// The session of [token], or null when it is unknown, expired, or its
  /// user may not sign in any more (`ALLOWED_EMAILS`). Throws when the
  /// database does not answer.
  Future<ApiSession?> verify(String token) async {
    Auth auth = _auth;
    User? user = await auth.userFromToken<User>(token);
    AccessToken? row = auth.currentAccessToken;
    if (user == null || row == null) return null;
    if (!userService.isEmailAllowed(user.email)) return null;
    return ApiSession(user, row);
  }

  /// A new token for the browser of [session], with the same two-step mark.
  /// The old one ends after [apiTokenRefreshGrace].
  Future<String> refresh(ApiSession session, {String? device}) async {
    await _auth.pruneExpiredAccessTokens();
    AccessToken token = await _auth.rotateAccessToken(
      session.token,
      grace: apiTokenRefreshGrace,
      name: device == null ? null : _deviceName(device),
    );
    return token.value!;
  }

  /// After the two-step code: this browser passes `TwoFactorMiddleware`.
  Future<void> markSecondFactor(AccessToken token) {
    return _auth.setAccessTokenAbilities(token, <String>[secondFactorAbility]);
  }

  /// Signs this browser out.
  Future<void> revoke(ApiSession session) async {
    await _auth.revokeAccessToken(session.user, session.token.id);
  }

  static String _deviceName(String? device) {
    String name = (device ?? '').trim();
    return name.length > 200 ? name.substring(0, 200) : name;
  }
}
