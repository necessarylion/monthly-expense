import 'dart:async';

import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

/// A tool of this app. The input is the same `@Dto` as the HTTP route, so
/// the model sees its `@Describe` hints and rules. Keys are camelCase. The
/// MCP route passes the user as `auth`.
///
/// Data comes back as JSON from the app's serializers ([json]), so Claude
/// sees the same fields as the web app. Money is in cents. Short answers
/// (a delete, no changes) are plain text.
///
/// Errors thrown in [run] come back as an error result
/// (`Error (<tool>): <message>`), not as a transport failure.
abstract class AppTool<T> extends McpDtoTool<T> {
  AppTool(this.groups);

  final GroupService groups;

  /// Run the tool for [user].
  Future<McpToolResult> run(T input, User user);

  @override
  Future<McpToolResult> handle(T input, McpContext context) async {
    try {
      return await run(input, context.authAs<User>());
    } catch (error) {
      String message = error is HttpError ? error.text : '$error';
      Logger.warn('[mcp] tool "$name" failed: $message');
      return McpToolResult.error('Error ($name): $message');
    }
  }

  /// The group, after checking the user belongs to it.
  Future<Group> groupOf(User user, int? groupId) {
    return groups.assertMembership(user, need(groupId, 'groupId'));
  }

  /// [value] of an id field that HTTP takes from the URL, so the DTO has
  /// it as optional. The tools need it.
  static int need(int? value, String key) {
    if (value == null) throw HttpError.unprocessable('$key is required');
    return value;
  }

  static McpToolResult text(String text) => McpToolResult.text(text);

  /// [value] as JSON text and as `structuredContent`.
  static McpToolResult json(Map<String, dynamic> value) {
    return McpToolResult.json(value);
  }

  /// A mistake the model can fix, like a bad id.
  static McpToolResult error(String text) => McpToolResult.error(text);
}
