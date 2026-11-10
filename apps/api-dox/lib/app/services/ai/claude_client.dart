import 'dart:convert';

import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:dox_core/dox_core.dart';
import 'package:http/http.dart' as http;

/// One call to the Claude Messages API that answers with JSON.
///
/// There is no official Anthropic SDK for Dart, so this is plain HTTP.
/// Null on any failure, or when no API key is set. Tests replace it.
@Inject()
class ClaudeClient {
  ClaudeClient(this.settings);

  final AppSettings settings;

  bool get enabled => (settings.anthropicApiKey ?? '').isNotEmpty;

  /// Haiku has no server-side fallback; sending one is an error.
  bool get _hasFallbacks => !settings.anthropicModel.contains('haiku');

  /// Asks Claude and returns its answer, parsed. [schema] is the JSON
  /// schema the answer must follow.
  Future<Object?> askJson({
    required String system,
    required String prompt,
    required Map<String, Object?> schema,
  }) async {
    if (!enabled) return null;
    http.Client client = http.Client();
    try {
      http.Response res = await client
          .post(
            Uri.parse(claudeMessagesUrl),
            headers: <String, String>{
              'content-type': 'application/json',
              'x-api-key': settings.anthropicApiKey!,
              'anthropic-version': claudeApiVersion,
              if (_hasFallbacks) 'anthropic-beta': claudeFallbackBeta,
            },
            body: jsonEncode(<String, Object?>{
              'model': settings.anthropicModel,
              'max_tokens': 4096,
              if (_hasFallbacks) 'fallbacks': 'default',
              'system': system,
              'output_config': <String, Object?>{
                'effort': 'low',
                'format': <String, Object?>{
                  'type': 'json_schema',
                  'schema': schema,
                },
              },
              'messages': <Map<String, Object?>>[
                <String, Object?>{'role': 'user', 'content': prompt},
              ],
            }),
          )
          .timeout(claudeTimeout);
      if (res.statusCode < 200 || res.statusCode >= 300) return null;
      return _answer(jsonDecode(utf8.decode(res.bodyBytes)));
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  /// The JSON in the first text block. Null for a refusal or a cut-off
  /// answer.
  static Object? _answer(Object? body) {
    if (body is! Map || body['stop_reason'] != 'end_turn') return null;
    Object? content = body['content'];
    if (content is! List) return null;
    for (Object? block in content) {
      if (block is Map && block['type'] == 'text' && block['text'] is String) {
        return jsonDecode(block['text'] as String);
      }
    }
    return null;
  }
}
