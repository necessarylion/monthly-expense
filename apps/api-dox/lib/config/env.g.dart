// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// Generator: DoxEnvBuilder
// **************************************************************************

class _$AppEnv extends AppEnv {
  _$AppEnv._({
    required this.appEnv,
    required this.appKey,
    required this.appTotalIsolate,
    required this.port,
    required this.host,
    required this.appUrl,
    required this.databaseUrl,
    required this.dbPath,
    required this.publicDir,
    required this.cacheDir,
    required this.frontendUrls,
    required this.allowedEmails,
    required this.firebaseProjectId,
    required this.firebaseClientEmail,
    required this.firebasePrivateKey,
    required this.logLevel,
  });

  @override
  final String appEnv;
  @override
  final String appKey;
  @override
  final int? appTotalIsolate;
  @override
  final int port;
  @override
  final String host;
  @override
  final String? appUrl;
  @override
  final String databaseUrl;
  @override
  final String dbPath;
  @override
  final String publicDir;
  @override
  final String cacheDir;
  @override
  final String frontendUrls;
  @override
  final String allowedEmails;
  @override
  final String? firebaseProjectId;
  @override
  final String? firebaseClientEmail;
  @override
  final String? firebasePrivateKey;
  @override
  final String logLevel;

  /// reads and checks every key once. Throws `EnvException` with all
  /// missing or bad keys.
  static AppEnv load([EnvReader? reader]) {
    EnvReader r = reader ?? EnvReader();
    _$AppEnvDefaults d = _$AppEnvDefaults();
    String appEnv = r.string('APP_ENV') ?? d.appEnv;
    String appKey = r.string('APP_KEY') ?? d.appKey;
    int? appTotalIsolate = r.integer('APP_TOTAL_ISOLATE');
    int port = r.integer('PORT') ?? d.port;
    String host = r.string('HOST') ?? d.host;
    String? appUrl = r.string('APP_URL');
    String databaseUrl = r.string('DATABASE_URL') ?? d.databaseUrl;
    String dbPath = r.string('DB_PATH') ?? d.dbPath;
    String publicDir = r.string('PUBLIC_DIR') ?? d.publicDir;
    String cacheDir = r.string('CACHE_DIR') ?? d.cacheDir;
    String frontendUrls = r.string('FRONTEND_URLS') ?? d.frontendUrls;
    String allowedEmails = r.string('ALLOWED_EMAILS') ?? d.allowedEmails;
    String? firebaseProjectId = r.string('FIREBASE_PROJECT_ID');
    String? firebaseClientEmail = r.string('FIREBASE_CLIENT_EMAIL');
    String? firebasePrivateKey = r.string('FIREBASE_PRIVATE_KEY');
    String logLevel = r.string('LOG_LEVEL') ?? d.logLevel;

    r.check();
    return _$AppEnv._(
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
      logLevel: logLevel,
    );
  }
}

/// gives the getter bodies of [AppEnv] (the defaults)
class _$AppEnvDefaults extends AppEnv {
  @override
  int? get appTotalIsolate =>
      throw StateError('APP_TOTAL_ISOLATE has no default');
  @override
  String? get appUrl => throw StateError('APP_URL has no default');
  @override
  String? get firebaseProjectId =>
      throw StateError('FIREBASE_PROJECT_ID has no default');
  @override
  String? get firebaseClientEmail =>
      throw StateError('FIREBASE_CLIENT_EMAIL has no default');
  @override
  String? get firebasePrivateKey =>
      throw StateError('FIREBASE_PRIVATE_KEY has no default');
}
