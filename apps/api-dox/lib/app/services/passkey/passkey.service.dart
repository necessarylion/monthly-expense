import 'dart:convert';
import 'dart:math';

import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/passkey.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/passkey/webauthn.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// Sign in with a passkey. A signed-in user adds one on the Me page. Later
/// the login page signs in with it: the API checks it and gives a Firebase
/// custom token, so the rest of the app still runs on Firebase ID tokens.
@Inject()
class PasskeyService {
  PasskeyService(
    this.passkeys,
    this.users,
    this.userService,
    this.firebase,
    this.settings,
  );

  final PasskeyRepository passkeys;
  final UserRepository users;
  final UserService userService;
  final FirebaseService firebase;
  final AppSettings settings;

  static final Random _random = Random.secure();

  /// The web app runs on `APP_URL`, or on a `FRONTEND_URLS` origin in dev.
  WebAuthn get _webAuthn => WebAuthn(<String>[
    Uri.parse(settings.appUrl).origin,
    for (String url in settings.frontendUrls) Uri.parse(url).origin,
  ]);

  Future<List<Passkey>> list(User user) => passkeys.listByUser(user.id!);

  /// Options for `navigator.credentials.create()`, base64url for bytes.
  /// No `rp.id`: the browser uses the page host.
  Future<Map<String, dynamic>> registrationOptions(User user) async {
    List<Passkey> existing = await passkeys.listByUser(user.id!);
    if (existing.length >= passkeysMax) {
      throw HttpError.unprocessable('Too many passkeys. Remove one first.');
    }
    String challenge = await _newChallenge('register', '${user.id}');
    return <String, dynamic>{
      'challenge': challenge,
      'rp': <String, String>{'name': 'Monthly Expense'},
      'user': <String, String>{
        'id': base64Url.encode(utf8.encode('${user.id}')).replaceAll('=', ''),
        'name': user.email,
        'displayName': user.displayName ?? user.email,
      },
      'pubKeyCredParams': <Map<String, Object>>[
        <String, Object>{'type': 'public-key', 'alg': WebAuthn.es256},
      ],
      'authenticatorSelection': <String, String>{
        'residentKey': 'required',
        'userVerification': 'required',
      },
      'attestation': 'none',
      'timeout': passkeyChallengeTtl.inMilliseconds,
      'excludeCredentials': <Map<String, String>>[
        for (Passkey p in existing)
          <String, String>{'type': 'public-key', 'id': p.credentialId},
      ],
    };
  }

  Future<void> register(
    User user, {
    required String credentialId,
    required String clientDataJson,
    required String authenticatorData,
    required String publicKey,
    required int publicKeyAlgorithm,
    required String name,
  }) async {
    WebAuthnClientData data = _guard(
      () => _webAuthn.checkRegistration(
        clientDataJson: clientDataJson,
        authenticatorData: authenticatorData,
        publicKey: publicKey,
        publicKeyAlgorithm: publicKeyAlgorithm,
      ),
    );
    if (await _takeChallenge('register', data.challenge) != '${user.id}') {
      throw HttpError.unprocessable('Passkey request expired. Try again.');
    }
    if (await passkeys.findByCredentialId(credentialId) != null) {
      throw HttpError.unprocessable('This passkey is already added');
    }
    await passkeys.create(
      userId: user.id!,
      credentialId: credentialId,
      publicKey: publicKey,
      signCount: data.signCount,
      name: name,
    );
  }

  Future<void> remove(User user, int id) async {
    if (!await passkeys.deleteForUser(user.id!, id)) {
      throw HttpError.notFound('Passkey not found');
    }
  }

  /// Options for `navigator.credentials.get()`. No `allowCredentials`: the
  /// browser shows the passkeys it has for this site.
  Future<Map<String, dynamic>> loginOptions() async {
    return <String, dynamic>{
      'challenge': await _newChallenge('login', '1'),
      'userVerification': 'required',
      'timeout': passkeyChallengeTtl.inMilliseconds,
    };
  }

  /// Checks the passkey and gives a Firebase custom token for its user.
  /// Every failure is a 401 with no detail, so it tells nothing about
  /// which passkeys exist.
  Future<String> login({
    required String credentialId,
    required String clientDataJson,
    required String authenticatorData,
    required String signature,
  }) async {
    Passkey? passkey = await passkeys.findByCredentialId(credentialId);
    User? user = passkey == null ? null : await users.findById(passkey.userId);
    if (passkey == null || user == null) throw _loginFailed();

    WebAuthnClientData data;
    try {
      data = _webAuthn.checkAssertion(
        clientDataJson: clientDataJson,
        authenticatorData: authenticatorData,
        signature: signature,
        publicKey: passkey.publicKey,
      );
    } on WebAuthnException catch (error) {
      Logger.warn('[passkey] login failed: ${error.reason}');
      throw _loginFailed();
    }
    if (await _takeChallenge('login', data.challenge) == null) {
      throw _loginFailed();
    }
    // A counter that does not go up means a copied key. Synced passkeys
    // always send 0, so 0 is fine.
    if (data.signCount != 0 && data.signCount <= passkey.signCount) {
      Logger.warn('[passkey] sign count did not go up: ${passkey.id}');
      throw _loginFailed();
    }
    if (!userService.isEmailAllowed(user.email)) {
      throw HttpError.unauthorized('This email is not allowed');
    }
    await passkeys.markUsed(passkey.id!, data.signCount);

    try {
      // A passkey is a device plus a face, finger or PIN: no code on top.
      return await firebase.createCustomToken(
        user.firebaseUid,
        secondFactor: true,
      );
    } catch (error) {
      Logger.danger('[passkey] createCustomToken failed: $error');
      throw HttpError(503, 'Sign-in is not available. Try again.');
    }
  }

  static HttpError _loginFailed() {
    return HttpError.unauthorized('Passkey sign-in failed');
  }

  static WebAuthnClientData _guard(WebAuthnClientData Function() check) {
    try {
      return check();
    } on WebAuthnException catch (error) {
      throw HttpError.unprocessable(error.reason);
    }
  }

  /// A random challenge, kept in the cache with [value] until used.
  Future<String> _newChallenge(String purpose, String value) async {
    List<int> bytes = <int>[for (int i = 0; i < 32; i++) _random.nextInt(256)];
    String challenge = base64Url.encode(bytes).replaceAll('=', '');
    await Cache().put(
      'passkey:$purpose:$challenge',
      value,
      duration: passkeyChallengeTtl,
    );
    return challenge;
  }

  /// The value of [challenge], and removes it, so it works once. Null when
  /// it is unknown or too old.
  Future<String?> _takeChallenge(String purpose, String challenge) async {
    Object? value = await Cache().pull('passkey:$purpose:$challenge');
    return value is String ? value : null;
  }
}
