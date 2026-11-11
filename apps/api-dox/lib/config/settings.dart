import 'package:api_dox/config/env.dart';
import 'package:dox_core/dox_core.dart';

/// Which database the app uses.
enum DatabaseClient { sqlite, postgres }

/// The settings the app code reads, made from the env. It is in the
/// container, so a test can replace it with `Dox().ioc.override`.
@Inject()
class AppSettings {
  final bool isProduction;
  final String appUrl;
  final DatabaseClient databaseClient;

  /// SQLite file path (sqlite only).
  final String sqlitePath;

  /// Connection string (postgres only).
  final String databaseUrl;
  final String publicDir;
  final String cacheDir;
  final List<String> frontendUrls;

  /// Only these emails may sign in. Empty = anyone.
  final List<String> allowedEmails;
  final String? firebaseProjectId;
  final String? firebaseClientEmail;
  final String? firebasePrivateKey;

  /// Firebase Web SDK config for the browser (`/config.js`).
  final String? firebaseApiKey;
  final String? firebaseAuthDomain;
  final String? firebaseAppId;

  /// Claude API key for expense categories and the quick-add list. Null:
  /// no AI.
  final String? anthropicApiKey;

  /// The Claude model for the AI features.
  final String anthropicModel;

  /// The settings from the env of this process.
  factory AppSettings() => AppSettings.fromEnv(env);

  const AppSettings.of({
    this.isProduction = false,
    this.appUrl = 'http://localhost:3333',
    this.databaseClient = DatabaseClient.sqlite,
    this.sqlitePath = './storage/db.sqlite3',
    this.databaseUrl = '',
    this.publicDir = './public',
    this.cacheDir = './storage/cache',
    this.frontendUrls = const <String>[],
    this.allowedEmails = const <String>[],
    this.firebaseProjectId,
    this.firebaseClientEmail,
    this.firebasePrivateKey,
    this.firebaseApiKey,
    this.firebaseAuthDomain,
    this.firebaseAppId,
    this.anthropicApiKey,
    this.anthropicModel = 'claude-opus-5-5',
  });

  factory AppSettings.fromEnv(AppEnv env) {
    String url = env.databaseUrl;
    return AppSettings.of(
      isProduction: env.isProduction,
      appUrl: _orDefault(env.appUrl, 'http://localhost:${env.port}'),
      databaseClient: url.startsWith('postgres')
          ? DatabaseClient.postgres
          : DatabaseClient.sqlite,
      sqlitePath: _orDefault(env.dbPath, './storage/db.sqlite3'),
      databaseUrl: url,
      publicDir: _orDefault(env.publicDir, './public'),
      cacheDir: _orDefault(env.cacheDir, './storage/cache'),
      frontendUrls: parseList(env.frontendUrls),
      allowedEmails: parseList(env.allowedEmails.toLowerCase()),
      firebaseProjectId: env.firebaseProjectId,
      firebaseClientEmail: env.firebaseClientEmail,
      firebasePrivateKey: env.firebasePrivateKey,
      firebaseApiKey: env.firebaseApiKey,
      firebaseAuthDomain: env.firebaseProjectId == null
          ? env.firebaseAuthDomain
          : _orDefault(
              env.firebaseAuthDomain,
              '${env.firebaseProjectId}.firebaseapp.com',
            ),
      firebaseAppId: env.firebaseAppId,
      anthropicApiKey: env.anthropicApiKey,
      anthropicModel: _orDefault(env.anthropicModel, 'claude-opus-5-5'),
    );
  }

  AppSettings copyWith({
    String? appUrl,
    String? publicDir,
    String? cacheDir,
    List<String>? frontendUrls,
    List<String>? allowedEmails,
  }) {
    return AppSettings.of(
      isProduction: isProduction,
      appUrl: appUrl ?? this.appUrl,
      databaseClient: databaseClient,
      sqlitePath: sqlitePath,
      databaseUrl: databaseUrl,
      publicDir: publicDir ?? this.publicDir,
      cacheDir: cacheDir ?? this.cacheDir,
      frontendUrls: frontendUrls ?? this.frontendUrls,
      allowedEmails: allowedEmails ?? this.allowedEmails,
      firebaseProjectId: firebaseProjectId,
      firebaseClientEmail: firebaseClientEmail,
      firebasePrivateKey: firebasePrivateKey,
      firebaseApiKey: firebaseApiKey,
      firebaseAuthDomain: firebaseAuthDomain,
      firebaseAppId: firebaseAppId,
      anthropicApiKey: anthropicApiKey,
      anthropicModel: anthropicModel,
    );
  }

  /// `"a, b,,c"` -> `["a", "b", "c"]`
  static List<String> parseList(String? value) {
    return <String>[
      for (String part in (value ?? '').split(','))
        if (part.trim().isNotEmpty) part.trim(),
    ];
  }

  static String _orDefault(String? value, String fallback) {
    return (value == null || value.isEmpty) ? fallback : value;
  }
}

/// The settings from the env of this process.
final AppSettings settings = AppSettings.fromEnv(env);
