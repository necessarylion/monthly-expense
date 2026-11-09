import 'dart:convert';

import 'package:api_dox/constants/fx.dart';
import 'package:dox_core/dox_core.dart';
import 'package:http/http.dart' as http;

/// GETs JSON from a rate provider, with a timeout. A provider that never
/// answers once hung every exchange-rate request, so every call has one.
/// Null on any failure. Tests replace it with a fake.
@Inject()
class HttpFetch {
  Future<Object?> getJson(String url) async {
    http.Client client = http.Client();
    try {
      http.Response res = await client
          .get(Uri.parse(url))
          .timeout(fxFetchTimeout);
      if (res.statusCode < 200 || res.statusCode >= 300) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
