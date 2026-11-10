import 'dart:convert';
import 'dart:math';

import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/api_token.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// A signed-in browser: the user, and the token row it sent.
class ApiSession {
  const ApiSession(this.user, this.token);

  final User user;
  final ApiToken token;

  /// This sign-in gave the two-step code, or used a passkey.
  bool get secondFactor => token.secondFactor == true;
}

/// The web app's own tokens. Firebase is checked once, at sign-in
/// ([signIn]); after that each call costs one lookup by hash, not a
/// Firebase check. Only the SHA-256 is stored, so a row can be deleted to
/// sign that browser out.
@Inject()
class ApiTokenService {
  ApiTokenService(this.tokens, this.users, this.userService, this.firebase);

  final ApiTokenRepository tokens;
  final UserRepository users;
  final UserService userService;
  final FirebaseService firebase;

  static final Random _random = Random.secure();

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

  /// A new token for [user]. Also clears the user's expired ones.
  Future<String> issue(
    User user, {
    required bool secondFactor,
    String? device,
  }) async {
    await tokens.deleteExpiredForUser(user.id!, DateUtil.nowSql());
    String token = _newToken();
    await tokens.create(
      userId: user.id!,
      tokenHash: hash(token),
      name: _deviceName(device),
      secondFactor: secondFactor,
      expiresAt: _expiresAt(),
    );
    return token;
  }

  /// The session of [token], or null when it is unknown, expired, or its
  /// user may not sign in any more (`ALLOWED_EMAILS`).
  Future<ApiSession?> verify(String token) async {
    if (!token.startsWith(apiTokenPrefix)) return null;
    ApiToken? row = await tokens.findByHash(hash(token));
    if (row == null) return null;
    DateTime now = DateTime.now().toUtc();
    if (_isPast(row.expiresAt, now)) {
      await tokens.delete(row.id!);
      return null;
    }
    User? user = await users.findById(row.userId);
    if (user == null || !userService.isEmailAllowed(user.email)) return null;
    if (_stale(row.lastUsedAt, now)) await tokens.touch(row.id!, _expiresAt());
    return ApiSession(user, row);
  }

  /// After the two-step code: this browser passes `TwoFactorMiddleware`.
  Future<void> markSecondFactor(ApiToken token) async {
    await tokens.markSecondFactor(token.id!);
    token.secondFactor = true;
  }

  /// Signs this browser out.
  Future<void> revoke(ApiToken token) => tokens.delete(token.id!);

  /// SHA-256 hex. Only this is stored.
  static String hash(String token) => Hash.sha256(token);

  static String _newToken() {
    List<int> bytes = <int>[for (int i = 0; i < 32; i++) _random.nextInt(256)];
    return '$apiTokenPrefix${base64Url.encode(bytes).replaceAll('=', '')}';
  }

  static String _expiresAt() {
    return DateUtil.timestampText(DateTime.now().toUtc().add(apiTokenLife))!;
  }

  static String _deviceName(String? device) {
    String name = (device ?? '').trim();
    return name.length > 200 ? name.substring(0, 200) : name;
  }

  static DateTime? _parse(String? text) {
    return text == null || text.isEmpty ? null : DateTime.tryParse('${text}Z');
  }

  static bool _isPast(String text, DateTime now) {
    DateTime? at = _parse(text);
    return at == null || !at.isAfter(now);
  }

  /// `last_used_at` (and the end) are written at most once an hour.
  static bool _stale(String? lastUsedAt, DateTime now) {
    DateTime? at = _parse(lastUsedAt);
    return at == null || now.difference(at) > apiTokenTouchEvery;
  }
}
