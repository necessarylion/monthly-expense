import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/http.dart';
import 'package:dox_core/dox_core.dart';

/// CORS headers for the allowed frontend origins only (`FRONTEND_URLS`).
/// Dox sends back the request `Origin` only when it is in the list, with
/// `Vary: Origin`. No credentials: the API uses bearer tokens, not
/// cookies.
CORSConfig cors = CORSConfig(
  origin: settings.frontendUrls,
  methods: corsMethods,
  headers: corsHeaders,
  maxAge: corsMaxAgeSeconds,
);
