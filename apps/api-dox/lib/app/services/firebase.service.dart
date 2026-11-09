import 'dart:convert';

import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:dox_core/dox_core.dart';
import 'package:firebase_admin_sdk/auth.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';

/// Who signed in: the fields of a Firebase ID token the app uses.
class FirebaseIdentity {
  final String uid;
  final String? email;
  final String? name;
  final String? picture;

  const FirebaseIdentity({
    required this.uid,
    this.email,
    this.name,
    this.picture,
  });
}

/// The ID token is bad: wrong signature, expired, wrong project, not a JWT.
class InvalidIdTokenException implements Exception {
  const InvalidIdTokenException(this.reason);

  final String reason;

  @override
  String toString() => 'InvalidIdTokenException: $reason';
}

/// Verifies Firebase ID tokens with the Firebase Admin SDK. The SDK starts
/// on first use. Each isolate has its own instance (and key cache).
@Inject()
class FirebaseService {
  FirebaseService(this.settings);

  final AppSettings settings;

  FirebaseApp? _app;

  /// Throws [InvalidIdTokenException] when the token itself is bad. Any other
  /// error (a timeout, Google's key endpoint down, no config) is ours, not the
  /// user's, so it must not log the user out.
  Future<FirebaseIdentity> verifyIdToken(String token) async {
    DecodedIdToken decoded;
    try {
      // The SDK fetches Google's public keys with no timeout of its own.
      decoded = await _getApp()
          .auth()
          .verifyIdToken(token)
          .timeout(firebaseVerifyTimeout);
    } on FirebaseAuthAdminException catch (error) {
      throw InvalidIdTokenException('$error');
    }
    Object? name = decoded.claims['name'];
    return FirebaseIdentity(
      uid: decoded.uid,
      email: decoded.email,
      name: name is String ? name : null,
      picture: decoded.picture,
    );
  }

  /// A token the web app trades for a Firebase session with
  /// `signInWithCustomToken`. Used after a passkey sign-in. The SDK signs
  /// it with the service account key, so there is no network call.
  Future<String> createCustomToken(String uid) {
    return _getApp().auth().createCustomToken(uid);
  }

  /// Starts the SDK at boot so a bad config shows up early. Never throws.
  void warmUp() {
    try {
      _getApp();
    } catch (error) {
      Logger.warn('[firebase] $error');
    }
  }

  FirebaseApp _getApp() {
    FirebaseApp? app = _app;
    if (app != null) return app;
    String? projectId = settings.firebaseProjectId;
    String? clientEmail = settings.firebaseClientEmail;
    String? privateKey = settings.firebasePrivateKey;
    if (_empty(projectId) || _empty(clientEmail) || _empty(privateKey)) {
      throw StateError(
        'Firebase is not configured. Set FIREBASE_PROJECT_ID, '
        'FIREBASE_CLIENT_EMAIL, and FIREBASE_PRIVATE_KEY.',
      );
    }
    app = FirebaseApp.initializeApp(
      options: AppOptions(
        projectId: projectId,
        credential: Credential.fromServiceAccountParams(
          projectId: projectId!,
          email: clientEmail!,
          privateKey: normalizePrivateKey(privateKey!),
        ),
      ),
    );
    _app = app;
    return app;
  }

  static bool _empty(String? value) => value == null || value.isEmpty;

  /// Deploy tools mangle the key in different ways. Accept:
  /// 1. real multi-line PEM, 2. one line with `\n` escapes, 3. base64 PEM.
  static String normalizePrivateKey(String raw) {
    String s = raw.trim();
    if ((s.startsWith('"') && s.endsWith('"')) ||
        (s.startsWith("'") && s.endsWith("'"))) {
      s = s.substring(1, s.length - 1);
    }
    String withNewlines = s.replaceAll(r'\\n', '\n').replaceAll(r'\n', '\n');
    if (withNewlines.contains('-----BEGIN')) return withNewlines;

    try {
      String decoded = utf8.decode(
        base64.decode(s.replaceAll(RegExp(r'\s+'), '')),
        allowMalformed: true,
      );
      if (decoded.contains('-----BEGIN')) return decoded;
    } on FormatException {
      // not base64
    }

    throw StateError(
      'FIREBASE_PRIVATE_KEY does not look like a PEM or base64-encoded PEM. '
      'Expected the string to contain "-----BEGIN" after normalization.',
    );
  }
}
