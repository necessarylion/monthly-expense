import 'package:api_dox/generated/openapi.g.dart';
import 'package:dox_core/dox_core.dart';

/// API docs at `/docs`, `/openapi.json` and `/openapi.yaml`, made from the
/// routes and controllers (`dart run build_runner build` writes the
/// registry). On only when `APP_ENV` is `development` or `local`.
OpenApiConfig openApi = OpenApiConfig(
  info: const Info(title: 'Monthly Expense API', version: '1.0.0'),
  registry: openApiRegistry,
  include: const <String>['/api/*'],
  // AuthMiddleware gets `bearerAuth` (the Firebase ID token) on its own.
  // ponytail: Dox joins the lists of each middleware, so group routes show
  // "bearerAuth OR groupId". The API needs both: set both in "Try it".
  securitySchemes: <String, SecurityScheme>{
    'groupId': SecurityScheme.apiKey(name: 'X-Group-Id'),
  },
  securityByMiddleware: const <String, List<Map<String, List<String>>>>{
    'GroupMiddleware': <Map<String, List<String>>>[
      <String, List<String>>{'groupId': <String>[]},
    ],
  },
);
