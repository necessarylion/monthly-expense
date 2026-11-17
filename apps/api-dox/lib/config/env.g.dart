// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// Generator: DoxEnvBuilder
// **************************************************************************

class _$AppEnv extends AppEnv {
  _$AppEnv._({
    required String? appEnv,
    required String? appKey,
    required this.appTotalIsolate,
    required int? port,
    required String? host,
    required this.appUrl,
    required String? databaseUrl,
    required String? dbPath,
    required String? publicDir,
    required String? cacheDir,
    required String? frontendUrls,
    required String? allowedEmails,
    required this.firebaseProjectId,
    required this.firebaseClientEmail,
    required this.firebasePrivateKey,
    required this.firebaseApiKey,
    required this.firebaseAuthDomain,
    required this.firebaseAppId,
    required this.anthropicApiKey,
    required String? anthropicModel,
    required String? logLevel,
  }) : _$appEnv = appEnv,
       _$appKey = appKey,
       _$port = port,
       _$host = host,
       _$databaseUrl = databaseUrl,
       _$dbPath = dbPath,
       _$publicDir = publicDir,
       _$cacheDir = cacheDir,
       _$frontendUrls = frontendUrls,
       _$allowedEmails = allowedEmails,
       _$anthropicModel = anthropicModel,
       _$logLevel = logLevel;

  final String? _$appEnv;
  @override
  late final String appEnv = _$appEnv ?? super.appEnv;
  final String? _$appKey;
  @override
  late final String appKey = _$appKey ?? super.appKey;
  @override
  final int? appTotalIsolate;
  final int? _$port;
  @override
  late final int port = _$port ?? super.port;
  final String? _$host;
  @override
  late final String host = _$host ?? super.host;
  @override
  final String? appUrl;
  final String? _$databaseUrl;
  @override
  late final String databaseUrl = _$databaseUrl ?? super.databaseUrl;
  final String? _$dbPath;
  @override
  late final String dbPath = _$dbPath ?? super.dbPath;
  final String? _$publicDir;
  @override
  late final String publicDir = _$publicDir ?? super.publicDir;
  final String? _$cacheDir;
  @override
  late final String cacheDir = _$cacheDir ?? super.cacheDir;
  final String? _$frontendUrls;
  @override
  late final String frontendUrls = _$frontendUrls ?? super.frontendUrls;
  final String? _$allowedEmails;
  @override
  late final String allowedEmails = _$allowedEmails ?? super.allowedEmails;
  @override
  final String? firebaseProjectId;
  @override
  final String? firebaseClientEmail;
  @override
  final String? firebasePrivateKey;
  @override
  final String? firebaseApiKey;
  @override
  final String? firebaseAuthDomain;
  @override
  final String? firebaseAppId;
  @override
  final String? anthropicApiKey;
  final String? _$anthropicModel;
  @override
  late final String anthropicModel = _$anthropicModel ?? super.anthropicModel;
  final String? _$logLevel;
  @override
  late final String logLevel = _$logLevel ?? super.logLevel;

  /// true while [load] runs. A default that reads the global `env` calls
  /// [load] again, and would loop until the stack overflows.
  static bool _$$loading = false;

  /// reads and checks every key once. Throws `EnvException` with all
  /// missing or bad keys. Then works out every default once, so a default
  /// that throws stops the app here, at startup.
  static AppEnv load([EnvReader? $reader]) {
    if (_$$loading) {
      throw StateError(
        'A default of AppEnv reads the global `env`. Use the getter directly: write `appEnv`, not `env.appEnv`.',
      );
    }
    _$$loading = true;
    try {
      EnvReader $r = $reader ?? EnvReader();
      String? appEnv = $r.string('APP_ENV');
      String? appKey = $r.string('APP_KEY');
      int? appTotalIsolate = $r.integer('APP_TOTAL_ISOLATE');
      int? port = $r.integer('PORT');
      String? host = $r.string('HOST');
      String? appUrl = $r.string('APP_URL');
      String? databaseUrl = $r.string('DATABASE_URL');
      String? dbPath = $r.string('DB_PATH');
      String? publicDir = $r.string('PUBLIC_DIR');
      String? cacheDir = $r.string('CACHE_DIR');
      String? frontendUrls = $r.string('FRONTEND_URLS');
      String? allowedEmails = $r.string('ALLOWED_EMAILS');
      String? firebaseProjectId = $r.string('FIREBASE_PROJECT_ID');
      String? firebaseClientEmail = $r.string('FIREBASE_CLIENT_EMAIL');
      String? firebasePrivateKey = $r.string('FIREBASE_PRIVATE_KEY');
      String? firebaseApiKey = $r.string('FIREBASE_API_KEY');
      String? firebaseAuthDomain = $r.string('FIREBASE_AUTH_DOMAIN');
      String? firebaseAppId = $r.string('FIREBASE_APP_ID');
      String? anthropicApiKey = $r.string('ANTHROPIC_API_KEY');
      String? anthropicModel = $r.string('ANTHROPIC_MODEL');
      String? logLevel = $r.string('LOG_LEVEL');

      $r.check();
      _$AppEnv $env = _$AppEnv._(
        appEnv: appEnv,
        appKey: appKey,
        appTotalIsolate: appTotalIsolate,
        port: port,
        host: host,
        appUrl: appUrl,
        databaseUrl: databaseUrl,
        dbPath: dbPath,
        publicDir: publicDir,
        cacheDir: cacheDir,
        frontendUrls: frontendUrls,
        allowedEmails: allowedEmails,
        firebaseProjectId: firebaseProjectId,
        firebaseClientEmail: firebaseClientEmail,
        firebasePrivateKey: firebasePrivateKey,
        firebaseApiKey: firebaseApiKey,
        firebaseAuthDomain: firebaseAuthDomain,
        firebaseAppId: firebaseAppId,
        anthropicApiKey: anthropicApiKey,
        anthropicModel: anthropicModel,
        logLevel: logLevel,
      );
      $env.appEnv;
      $env.appKey;
      $env.port;
      $env.host;
      $env.databaseUrl;
      $env.dbPath;
      $env.publicDir;
      $env.cacheDir;
      $env.frontendUrls;
      $env.allowedEmails;
      $env.anthropicModel;
      $env.logLevel;

      return $env;
    } finally {
      _$$loading = false;
    }
  }
}
