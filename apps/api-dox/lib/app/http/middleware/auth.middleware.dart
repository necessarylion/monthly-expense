import 'package:api_dox/app/services/api_token.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

final RegExp _bearer = RegExp(r'^Bearer\s+(.+)$', caseSensitive: false);

/// The bearer token of a web app call: an API token from `POST /auth/token`
/// (see `ApiTokenService`). Firebase is not called here.
String? bearerToken(DoxRequest req) {
  String? token = _bearer
      .firstMatch(req.header('authorization') ?? '')
      ?.group(1);
  return token == null || token.isEmpty ? null : token;
}

/// Every API call carries the API token as `Authorization: Bearer`. Find
/// its row and its user.
@Inject()
class AuthMiddleware implements IDoxMiddleware {
  AuthMiddleware(this.tokens);

  final ApiTokenService tokens;

  @override
  Future<dynamic> handle(IDoxRequest request) async {
    DoxRequest req = request as DoxRequest;
    String? token = bearerToken(req);
    if (token == null) throw HttpError.unauthorized('Missing bearer token');

    ApiSession? session;
    try {
      session = await tokens.verify(token);
    } catch (error, stack) {
      // Not a 401: the web app logs the user out on every 401.
      Logger.danger('[auth] token check failed: $error\n$stack');
      throw HttpError(503, 'Sign-in check is not available. Try again.');
    }
    if (session == null) throw HttpError.unauthorized('Invalid token');

    req.authUser = session.user;
    req.authToken = session.token;
    req.secondFactorDone = session.secondFactor;
    return req;
  }
}
