import 'package:api_dox/app/http/middleware/auth.middleware.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/serializers/user.serializer.dart';
import 'package:api_dox/app/services/api_token.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// The web app's API token. It signs in with Firebase, trades the ID token
/// for an API token once, and sends that on every call after. It renews
/// the API token itself, so Firebase is never needed again.
@Inject()
@Tags(<String>['Auth'])
class AuthController {
  AuthController(this.tokens);

  final ApiTokenService tokens;

  @Summary('Trade a Firebase ID token for an API token')
  @Description(
    'Send the Firebase ID token as `Authorization: Bearer`. Gives `token` (send it as the bearer token from now on) and the user. A user with two-step sign-in on still needs the code (`POST /me/totp/verify`) unless the ID token has the `mfa` claim.',
  )
  Future<Map<String, dynamic>> store(DoxRequest req) async {
    String? idToken = bearerToken(req);
    if (idToken == null) throw HttpError.unauthorized('Missing bearer token');
    (String, User) signedIn = await tokens.signIn(
      idToken,
      device: req.header('user-agent'),
    );
    return JsonResponse.ok(<String, dynamic>{
      'token': signedIn.$1,
      'user': UserSerializer(signedIn.$2).toJson(),
    });
  }

  @Summary('Trade the API token for a new one')
  @Description(
    'The web app calls it about once a day, so its token never runs out. The old token still works for two minutes. No Firebase.',
  )
  Future<Map<String, dynamic>> refresh(DoxRequest req) async {
    String token = await tokens.refresh(
      ApiSession(req.authUser, req.authToken),
      device: req.header('user-agent'),
    );
    return JsonResponse.ok(<String, String>{'token': token});
  }

  @Summary('Sign out this browser')
  @Description('The API token stops working.')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req) async {
    await tokens.revoke(req.authToken);
    return JsonResponse.noContent();
  }
}
