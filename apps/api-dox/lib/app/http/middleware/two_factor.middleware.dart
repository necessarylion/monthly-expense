import 'package:api_dox/constants/http.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// Runs after `AuthMiddleware`. A user with two-step sign-in on must have
/// given the code for this sign-in (see `TotpService`). If not: 403 with
/// `code: mfa_required`, and the web app asks for the code. Not a 401: the
/// web app logs the user out on every 401.
class TwoFactorMiddleware implements IDoxMiddleware {
  @override
  Future<dynamic> handle(IDoxRequest request) async {
    DoxRequest req = request as DoxRequest;
    if (req.authUser.totpEnabled == true && !req.secondFactorDone) {
      throw HttpError(403, 'Two-step code needed', <String, dynamic>{
        'code': mfaRequiredCode,
      });
    }
    return req;
  }
}
