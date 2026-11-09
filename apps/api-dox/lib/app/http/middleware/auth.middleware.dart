import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

final RegExp _bearer = RegExp(r'^Bearer\s+(.+)$', caseSensitive: false);

/// Every API request carries a Firebase ID token as `Authorization: Bearer`.
/// Verify it, then load (or create) the user. No sessions.
@Inject()
class AuthMiddleware implements IDoxMiddleware {
  AuthMiddleware(this.firebase, this.users);

  final FirebaseService firebase;
  final UserService users;

  @override
  Future<dynamic> handle(IDoxRequest request) async {
    DoxRequest req = request as DoxRequest;
    String? token = _bearer
        .firstMatch(req.header('authorization') ?? '')
        ?.group(1);
    if (token == null || token.isEmpty) {
      throw HttpError.unauthorized('Missing bearer token');
    }

    FirebaseIdentity identity;
    try {
      identity = await firebase.verifyIdToken(token);
    } on InvalidIdTokenException catch (error) {
      Logger.warn('[auth] Firebase verifyIdToken failed: $error');
      throw HttpError.unauthorized('Invalid Firebase ID token');
    } catch (error) {
      // Not a 401: the web app logs the user out on every 401.
      Logger.danger('[auth] Firebase is not reachable: $error');
      throw HttpError(503, 'Sign-in check is not available. Try again.');
    }

    if (!users.isEmailAllowed(identity.email)) {
      throw HttpError.unauthorized('This email is not allowed');
    }

    try {
      req.authUser = await users.findOrCreate(identity);
    } catch (error, stack) {
      Logger.danger('[auth] findOrCreate failed: $error\n$stack');
      // the error text can hold SQL; it is in the log above
      throw HttpError(500, 'User setup failed');
    }
    return req;
  }
}
