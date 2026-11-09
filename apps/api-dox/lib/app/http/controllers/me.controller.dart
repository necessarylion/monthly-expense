import 'package:api_dox/app/serializers/mcp_token.serializer.dart';
import 'package:api_dox/app/serializers/user.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/mcp_oauth.service.dart';
import 'package:api_dox/app/services/mcp_token.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class MeController {
  MeController(this.oauth, this.tokens);

  final McpOAuthService oauth;
  final McpTokenService tokens;

  Map<String, dynamic> show(DoxRequest req) {
    return JsonResponse.ok(UserSerializer(req.authUser).toJson());
  }

  /// The MCP address and the clients that signed in
  ///
  /// The address has no token: a client signs in with OAuth by itself.
  /// `url` keeps the shape older clients read.
  Future<Map<String, dynamic>> mcp(DoxRequest req) async {
    return JsonResponse.ok(await _mcp(req.authUser));
  }

  /// Sign out every MCP client
  ///
  /// The old "rotate the token" button. The web app still calls it.
  Future<Map<String, dynamic>> rotateMcp(DoxRequest req) async {
    await tokens.revokeAll(req.authUser);
    return JsonResponse.ok(await _mcp(req.authUser));
  }

  /// Sign out one MCP client
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
