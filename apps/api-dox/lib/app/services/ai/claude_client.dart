import 'dart:convert';

import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:dox_core/dox_core.dart';
import 'package:http/http.dart' as http;

/// One call to the Claude Messages API, answered with JSON or text.
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
    String? text = await _ask(system, prompt, claudeTimeout, <String, Object?>{
      'effort': 'low',
      'format': <String, Object?>{'type': 'json_schema', 'schema': schema},
    });
    if (text == null) return null;
    try {
      return jsonDecode(text);
    } on FormatException catch (error) {
      Logger.warn('[claude] answer is not JSON: $error');
      return null;
    }
  }

  /// Asks Claude and returns its answer as plain text.
  Future<String?> askText({
    required String system,
    required String prompt,
    Duration timeout = claudeTimeout,
  }) {
    return _ask(system, prompt, timeout, <String, Object?>{'effort': 'low'});
  }

  Future<String?> _ask(
    String system,
    String prompt,
    Duration timeout,
    Map<String, Object?> outputConfig,
  ) async {
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
              // The system prompts are fixed text, so Anthropic caches them:
              // a call within 5 minutes reads them at a fraction of the price.
              // Under 512 tokens nothing is cached, and nothing breaks.
              'system': <Map<String, Object?>>[
                <String, Object?>{
                  'type': 'text',
                  'text': system,
                  'cache_control': <String, Object?>{'type': 'ephemeral'},
                },
              ],
              'output_config': outputConfig,
              'messages': <Map<String, Object?>>[
                <String, Object?>{'role': 'user', 'content': prompt},
              ],
            }),
          )
          .timeout(timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        Logger.warn('[claude] HTTP ${res.statusCode}: ${res.body}');
        return null;
      }
      // Parses the bytes directly, with no String copy in between.
      Object? body = utf8.decoder.fuse(json.decoder).convert(res.bodyBytes);
      if (body is Map && body['usage'] is Map) {
        Map<dynamic, dynamic> usage = body['usage'] as Map<dynamic, dynamic>;
        Logger.info(
          '[claude] ${body['model']}: ${usage['input_tokens']} in, '
          '${usage['cache_read_input_tokens'] ?? 0} cached, '
          '${usage['cache_creation_input_tokens'] ?? 0} to cache, '
          '${usage['output_tokens']} out',
        );
      }
      return _answer(body);
    } catch (error) {
      Logger.warn('[claude] call failed: $error');
      return null;
    } finally {
      client.close();
    }
  }

  /// The first text block. Null for a refusal or a cut-off answer.
  static String? _answer(Object? body) {
    if (body is! Map || body['stop_reason'] != 'end_turn') return null;
    Object? content = body['content'];
    if (content is! List) return null;
    for (Object? block in content) {
      if (block is Map && block['type'] == 'text' && block['text'] is String) {
        return block['text'] as String;
      }
    }
    return null;
  }
}
