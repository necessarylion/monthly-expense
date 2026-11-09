import 'package:api_dox/app/serializers/mcp_token.serializer.dart';
import 'package:api_dox/app/serializers/user.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/mcp_oauth.service.dart';
import 'package:api_dox/app/services/mcp_token.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Me'])
class MeController {
  MeController(this.oauth, this.tokens);

  final McpOAuthService oauth;
  final McpTokenService tokens;

  @Summary('Get the signed-in user')
  Map<String, dynamic> show(DoxRequest req) {
    return JsonResponse.ok(UserSerializer(req.authUser).toJson());
  }

  @Summary('MCP address and clients')
  @Description(
    'The address has no token: a client signs in with OAuth by itself. `url` keeps the shape older clients read.',
  )
  Future<Map<String, dynamic>> mcp(DoxRequest req) async {
    return JsonResponse.ok(await _mcp(req.authUser));
  }

  @Summary('Sign out every MCP client')
  @Description('The old "rotate the token" button. The web app still calls it.')
  Future<Map<String, dynamic>> rotateMcp(DoxRequest req) async {
    await tokens.revokeAll(req.authUser);
    return JsonResponse.ok(await _mcp(req.authUser));
  }

  @Summary('Sign out one MCP client')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> revokeMcpClient(DoxRequest req, int id) async {
    await tokens.revoke(req.authUser, id);
    return JsonResponse.noContent();
  }

  Future<Map<String, dynamic>> _mcp(User user) async {
    List<McpToken> clients = await tokens.list(user);
    return <String, dynamic>{
      'url': oauth.mcpUrl,
      'clients': McpTokenSerializer(clients).toJson(),
    };
  }
}
