import 'package:dox_core/dox_core.dart';

part 'env.g.dart';

/// The env of the app, typed. Each getter reads one key: `appUrl` reads
/// `APP_URL`. A getter body is the default. A nullable getter is optional.
/// Run `dart run build_runner build` after you change this class.
///
/// The keys are the same as the Bun API's, so a deploy only needs
/// `APP_KEY` on top.
@DoxEnv()
abstract class AppEnv {
  /// reads and checks every key once
  static AppEnv load([EnvReader? reader]) {
    return _$AppEnv.load(reader);
  }

  /// development, testing or production. Not set: production.
  String get appEnv => 'production';

  /// 32 characters. Signs the MCP session ids. Required in production.
  String get appKey => '';

  /// isolates (threads) of the HTTP server. Null: one per CPU core.
  int? get appTotalIsolate;

  int get port => 3333;

  String get host => '0.0.0.0';

  /// The public URL of the app, for the MCP link. Null: localhost.
  String? get appUrl;

  /// A `postgres://` URL uses Postgres. Empty: SQLite at [dbPath].
  String get databaseUrl => '';

  String get dbPath => './storage/db.sqlite3';

  /// The built SPA, relative to the working directory.
  String get publicDir => './public';

  /// JSON file cache (exchange rates), relative to the working directory.
  String get cacheDir => './storage/cache';

  /// Comma separated origins that may call the API from a browser.
  String get frontendUrls => '';

  /// Comma separated emails that may sign in. Empty: anyone.
  String get allowedEmails => '';

  String? get firebaseProjectId;

  String? get firebaseClientEmail;

  String? get firebasePrivateKey;

  /// Firebase Web SDK config. `/config.js` sends it to the browser at run
  /// time, so one image works with any Firebase project. Not secret.
  String? get firebaseApiKey;

  /// Empty: `<FIREBASE_PROJECT_ID>.firebaseapp.com`.
  String? get firebaseAuthDomain;

  String? get firebaseAppId;

  /// Claude API key. Picks expense categories and cleans up the quick-add
  /// list. Empty: no AI.
  String? get anthropicApiKey;

  /// The Claude model for the AI features.
  String get anthropicModel => 'claude-opus-5-5';

  String get logLevel => 'info';
}

/// Read from [AppEnv.appEnv]. They live in an extension, not in the class,
/// because the generator reads every class getter as its own env key
/// (`IS_PRODUCTION`), and then `APP_ENV` would have no effect.
extension AppEnvMode on AppEnv {
  bool get isProduction => appEnv == 'production';

  bool get isDevelopment => appEnv == 'development';
}

/// The env of the app. Read and checked once, on first use.
final AppEnv env = AppEnv.load();
