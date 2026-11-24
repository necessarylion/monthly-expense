import 'dart:convert';

import 'package:api_dox/constants/fx.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_http_client/dox_http_client.dart';

/// GETs JSON from a rate provider, with a timeout. A provider that never
/// answers once hung every exchange-rate request, so every call has one.
/// Null on any failure. Tests replace it with a fake.
@Inject()
class HttpFetch {
  /// One client for the isolate: it keeps its connections open.
  late final DoxHttpClient _client = DoxHttpClient();

  Future<Object?> getJson(
    String url, {
    Duration timeout = fxFetchTimeout,
  }) async {
    try {
      DoxHttpClientResponse res = await _client.get(
        Uri.parse(url),
        timeout: timeout,
      );
      if (res.statusCode < 200 || res.statusCode >= 300) return null;
      // Parses the bytes directly, with no String copy in between.
      return utf8.decoder.fuse(json.decoder).convert(res.bodyBytes);
    } catch (_) {
      return null;
    }
  }
}
