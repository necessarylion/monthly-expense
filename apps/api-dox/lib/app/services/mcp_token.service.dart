import 'dart:convert';
import 'dart:math';

import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/mcp_token.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

/// The MCP access tokens: one per client that signed in with OAuth.
/// `dox_mcp`'s `McpOAuth` calls [issue] and [verify]; the Me page lists
/// and deletes them.
@Inject()
class McpTokenService extends McpOAuthTokens {
  McpTokenService(this.tokens, this.users, this.userService);

  final McpTokenRepository tokens;
  final UserRepository users;
  final UserService userService;

  static final Random _random = Random.secure();

  /// [grant.subject] is the user id, from `McpOAuthService.approve`.
  @override
  Future<String> issue(McpOAuthGrant grant) async {
    int userId = int.parse(grant.subject);
    if (await tokens.countByUser(userId) >= mcpClientsMax) {
      throw const McpOAuthException(
        'access_denied',
        'Too many MCP clients. Remove one on the Me page first.',
      );
    }
    String token = _newToken();
    String host = Uri.tryParse(grant.redirectUri)?.host ?? '';
    String name = host.isEmpty
        ? grant.client.name
        : '${grant.client.name} ($host)';
    await tokens.create(userId, name, hash(token));
    return token;
  }

  /// The user of [token], or null. The user must still be allowed to sign
  /// in (`ALLOWED_EMAILS`), like on the web.
  @override
  Future<Object?> verify(String token) async {
    McpToken? row = await tokens.findByHash(hash(token));
    if (row == null) return null;
    User? user = await users.findById(row.userId);
    if (user == null || !userService.isEmailAllowed(user.email)) return null;
    if (_stale(row.lastUsedAt)) await tokens.touch(row.id!);
    return user;
  }

  Future<bool> isFull(User user) async {
    return await tokens.countByUser(user.id!) >= mcpClientsMax;
  }

  Future<List<McpToken>> list(User user) => tokens.listByUser(user.id!);

  Future<void> revoke(User user, int id) async {
    if (!await tokens.deleteForUser(user.id!, id)) {
      throw HttpError.notFound('MCP client not found');
    }
  }

  Future<void> revokeAll(User user) => tokens.deleteAllForUser(user.id!);

  /// SHA-256 hex. Only this is stored.
  static String hash(String token) => Hash.sha256(token);

  static String _newToken() {
    List<int> bytes = <int>[for (int i = 0; i < 32; i++) _random.nextInt(256)];
    return '$mcpTokenPrefix${base64Url.encode(bytes).replaceAll('=', '')}';
  }

  /// `last_used_at` is written at most once a minute, not on every call.
  static bool _stale(String? lastUsedAt) {
    if (lastUsedAt == null) return true;
    DateTime? at = DateTime.tryParse('${lastUsedAt}Z');
    return at == null || DateTime.now().toUtc().difference(at) > mcpTouchEvery;
  }
}
