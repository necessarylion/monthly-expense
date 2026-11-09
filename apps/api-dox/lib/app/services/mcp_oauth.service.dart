import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/mcp_token.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

/// The OAuth sign-in of the MCP server (`dox_mcp`'s `McpOAuth`), set up for
/// this app: the issuer is `APP_URL`, the consent page is the web app's
/// `/oauth/authorize`, and the tokens are [McpTokenService].
@Inject()
class McpOAuthService {
  McpOAuthService(this.settings, this.tokens);

  final AppSettings settings;
  final McpTokenService tokens;

  /// Made on first use: `Cache()` needs the app to be started.
  late final McpOAuth oauth = McpOAuth(
    issuer: settings.appUrl,
    tokens: tokens,
    // one-time codes, shared by every isolate
    codes: Cache().store('file'),
    resourceName: 'Monthly Expense',
  );

  /// The address a client is given: `<APP_URL>/mcp`.
  String get mcpUrl => oauth.resource;

  /// The client asking, for the consent page. 422 when the client or its
  /// redirect address is wrong: the page then sends the browser nowhere.
  McpOAuthClient check(String clientId, String redirectUri) {
    try {
      return oauth.checkClient(clientId, redirectUri);
    } on McpOAuthException catch (error) {
      throw HttpError.unprocessable(error.description);
    }
  }

  Future<String> approve(
    User user, {
    required String clientId,
    required String redirectUri,
    required String codeChallenge,
    required String codeChallengeMethod,
    String? state,
    String? resource,
  }) async {
    if (await tokens.isFull(user)) {
      throw HttpError.unprocessable(
        'You have $mcpClientsMax MCP clients. Remove one first.',
      );
    }
    try {
      return await oauth.approve(
        subject: '${user.id}',
        clientId: clientId,
        redirectUri: redirectUri,
        codeChallenge: codeChallenge,
        codeChallengeMethod: codeChallengeMethod,
        state: state,
        resource: resource,
      );
    } on McpOAuthException catch (error) {
      throw HttpError.unprocessable(error.description);
    }
  }

  String deny({
    required String clientId,
    required String redirectUri,
    String? state,
  }) {
    try {
      return oauth.deny(
        clientId: clientId,
        redirectUri: redirectUri,
        state: state,
      );
    } on McpOAuthException catch (error) {
      throw HttpError.unprocessable(error.description);
    }
  }
}
