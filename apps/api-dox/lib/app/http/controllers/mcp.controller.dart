import 'package:api_dox/app/mcp/mcp_tool_registry.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/mcp_oauth.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

/// `/mcp`, the MCP Streamable HTTP transport. A client signs in with OAuth
/// (`dox_mcp`'s `McpOAuth`) and sends `Authorization: Bearer <token>`.
///
/// Sessions are signed ids (`dox_mcp`), tied to the user. Every isolate
/// can check them, and they survive a restart.
@Inject()
@Tags(<String>['MCP'])
class McpController {
  McpController(this.auth, McpToolRegistry registry)
    : server = McpServer(
        name: 'monthly-expense',
        version: '1.0.0',
        tools: registry.tools,
        // remembers ids ended with DELETE, so they stop working
        sessions: SignedMcpSessions(ended: Cache().store('file')),
        onToolError: _logToolError,
      );

  final McpOAuthService auth;
  final McpServer server;

  @Summary('MCP endpoint')
  @Description('One MCP request. The client signs in with an OAuth token.')
  Future<DoxResponse> handle(DoxRequest req) async {
    Object? user = await auth.oauth.authenticate(req);
    if (user is! User) return auth.oauth.unauthorized();
    return server.handle(req, auth: user, scope: 'user:${user.id}');
  }

  static void _logToolError(String tool, Object error, StackTrace stack) {
    Logger.danger('[mcp] tool "$tool" failed: $error\n$stack');
  }
}
