import 'dart:io';

import 'package:api_dox/config/database.dart';
import 'package:api_dox/config/env.dart';
import 'package:dox_migration/dox_migration.dart';

import '../db/migration/migrations.dart';

/// run the migrations of db/migration (Dart and .sql files):
/// `dart run bin/migrate.dart <run|rollback [--step=n]|reset|refresh|status>`.
/// `dox migration:*` commands run this file.
/// the database is the one of lib/config/database.dart (DATABASE_URL or DB_PATH).
Future<void> main(List<String> args) async {
  // `fresh` drops every table, Bun's too. Never on the production data.
  if (env.isProduction && args.any(_destructive.contains)) {
    stderr.writeln('${args.join(' ')} is blocked when APP_ENV=production.');
    exitCode = 1;
    return;
  }
  exitCode = await Migrator(
    migrations: migrations,
    config: databaseConfig.getConnectionConfig(),
  ).run(args);
}

const Set<String> _destructive = <String>{
  'fresh',
  'reset',
  'refresh',
  'rollback',
};
