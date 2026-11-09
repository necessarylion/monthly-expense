import 'package:api_dox/app/dtos/oauth/oauth.dto.dart';
import 'package:api_dox/app/services/mcp_oauth.service.dart';
import 'package:api_dox/app/services/mcp_token.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

/// The API behind the web app's consent page (`/oauth/authorize`). The
/// person is signed in (Firebase), so these routes know who says yes.
@Inject()
@Tags(<String>['OAuth'])
class OauthController {
  OauthController(this.oauth, this.tokens);

  final McpOAuthService oauth;
  final McpTokenService tokens;

  @Summary('Get the OAuth client')
  @Description(
    'Its name and the host the code goes to, for the consent page. 422 when the client or the redirect address is wrong.',
  )
  Future<Map<String, dynamic>> client(
    DoxRequest req,
    OauthClientQuery query,
  ) async {
    McpOAuthClient found = oauth.check(query.clientId, query.redirectUri);
    return JsonResponse.ok(<String, dynamic>{
      'name': found.name,
      'redirectHost': Uri.parse(query.redirectUri).host,
      'full': await tokens.isFull(req.authUser),
    });
  }

  @Summary('Allow the OAuth client')
  @Description(
    'Gives the address to send the browser to, with a one-time code.',
  )
  Future<Map<String, dynamic>> approve(
    DoxRequest req,
    ApproveOauth body,
  ) async {
    String url = await oauth.approve(
      req.authUser,
      clientId: body.clientId,
      redirectUri: body.redirectUri,
      codeChallenge: body.codeChallenge,
      codeChallengeMethod: body.codeChallengeMethod,
      state: body.state,
      resource: body.resource,
    );
    return JsonResponse.ok(<String, String>{'url': url});
  }

  @Summary('Deny the OAuth client')
  @Description(
    'Gives the address to send the browser back to, with `access_denied`.',
  )
  Map<String, dynamic> deny(DenyOauth body) {
    String url = oauth.deny(
      clientId: body.clientId,
      redirectUri: body.redirectUri,
      state: body.state,
    );
    return JsonResponse.ok(<String, String>{'url': url});
  }
}
