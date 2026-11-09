import 'package:api_dox/config/env.dart';
import 'package:api_dox/config/settings.dart';
import 'package:dox_orm/dox_orm.dart';

/// Print every SQL query only in development.
bool _debug = env.isDevelopment;

bool get _postgres => settings.databaseClient == DatabaseClient.postgres;

/// The postgres url, with its options (like `sslmode`). The pool is
/// shared by all isolates of the process, so 10 is the limit for the
/// whole process. `?maxConnectionCount=20` in the url wins.
ConnectionConfig _postgresConfig() {
  return ConnectionConfig.fromUrl(
    settings.databaseUrl,
    debug: _debug,
    printer: PrettyQueryPrinter(),
    extra: <String, dynamic>{'maxConnectionCount': 10},
  );
}

/// `DATABASE_URL=postgres://...` uses Postgres, otherwise SQLite at
/// `DB_PATH`. Code above the repositories does not care which.
DatabaseConfig databaseConfig = DatabaseConfig(
  connection: _postgres ? 'postgres' : 'sqlite',

  /// An empty url turns Dox's own `DATABASE_URL` reading off: a value that
  /// is not a postgres url falls back to SQLite, like the Bun API did.
  url: '',
  connections: <String, ConnectionConfig>{
    if (_postgres) 'postgres': _postgresConfig(),
    'sqlite': ConnectionConfig(
      driver: Driver.sqlite,
      database: settings.sqlitePath,
      debug: _debug,
      printer: PrettyQueryPrinter(),
    ),
  },
);
