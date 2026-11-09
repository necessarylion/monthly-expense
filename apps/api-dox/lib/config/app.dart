import 'dart:io';

import 'package:api_dox/app/exception_handler.dart';
import 'package:api_dox/config/cache.dart';
import 'package:api_dox/config/cors.dart';
import 'package:api_dox/config/env.dart';
import 'package:api_dox/config/logger.dart';
import 'package:api_dox/config/openapi.dart';
import 'package:api_dox/constants/http.dart';
import 'package:api_dox/generated/container.g.dart';
import 'package:api_dox/generated/dtos.g.dart';
import 'package:api_dox/routes/api.dart';
import 'package:api_dox/routes/web.dart';
import 'package:dox_core/dox_core.dart';

AppConfig appConfig = AppConfig(
  /// 32 characters. Signs the MCP session ids. Required in production.
  appKey: env.appKey,

  serverPort: env.port,
  host: env.host,

  /// One isolate per CPU core by default. Set `APP_TOTAL_ISOLATE` to
  /// change it.
  totalIsolate: env.appTotalIsolate ?? Platform.numberOfProcessors,

  /// one log line per request, off in production (the proxy logs there)
  globalMiddleware: <dynamic>[LogMiddleware(enabled: env.isDevelopment)],

  /// Every @Inject class and provider, from lib/generated/container.g.dart
  /// (made by build_runner). A test can replace one with
  /// `Dox().ioc.override`, like `AppSettings` or `FirebaseService`.
  container: registerContainer,

  /// Every @Dto class, from lib/generated/dtos.g.dart (build_runner).
  dtos: dtos,

  /// API routes first, then the SPA fallback.
  routers: <Router>[ApiRouter(), WebRouter()],

  exceptionHandler: const AppExceptionHandler(),
  cache: cache,
  cors: cors,
  logger: logger,
  openApi: openApi,
  idleTimeout: idleTimeout,
);
