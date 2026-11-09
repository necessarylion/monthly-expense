import 'dart:io';

import 'package:api_dox/config/database.dart';
import 'package:api_dox/config/settings.dart';
import 'package:api_dox/config/settings.dart' as app show settings;
import 'package:dox_core/dox_core.dart';
import 'package:dox_migration/dox_migration.dart';
import 'package:dox_orm/dox_orm.dart';
import 'package:path/path.dart' as p;

/// Runs pending migrations. On SQLite it first copies the DB file to a
/// backup (`<db>.backup-<ms>`), when there is something to run and the DB
/// already has data.
///
/// Dox runs each migration in a transaction, turns foreign keys off on
/// SQLite while it runs, and checks them after. Still: never rebuild a
/// table that other tables reference with ON DELETE CASCADE (see
/// CLAUDE.md). On Postgres, take a pg_dump before deploying a migration.
class DbMigrator {
  DbMigrator(this.migrations, {AppSettings? settings, ConnectionConfig? config})
    : settings = settings ?? app.settings,
      config = config ?? databaseConfig.getConnectionConfig();

  final List<MigrationEntry> migrations;
  final AppSettings settings;
  final ConnectionConfig config;

  Future<void> run() async {
    bool sqlite = settings.databaseClient == DatabaseClient.sqlite;
    String path = settings.sqlitePath;
    if (sqlite && path != ':memory:') {
      await Directory(p.dirname(path)).create(recursive: true);
    }
    Migrator migrator = Migrator(migrations: migrations, config: config);
    List<MigrationStatus> status = await migrator.status();
    List<String> pending = <String>[
      for (MigrationStatus s in status)
        if (!s.ran) s.name,
    ];
    if (pending.isEmpty) return;
    if (sqlite) await _backup(path);
    await migrator.migrate();
    for (String name in pending) {
      Logger.info('[migrate] $name: Success');
    }
  }

  /// `VACUUM INTO` a backup file, only when the DB has a `users` table.
  Future<void> _backup(String path) async {
    if (path == ':memory:' || !File(path).existsSync()) return;
    DBDriver driver = config.createDriver();
    try {
      List<Map<String, dynamic>> users = await driver.query(
        "SELECT 1 AS found FROM sqlite_master WHERE type = 'table' AND name = 'users'",
      );
      if (users.isEmpty) return;
      String target = '$path.backup-${DateTime.now().millisecondsSinceEpoch}';
      await driver.execute(
        'VACUUM INTO @target',
        substitutionValues: <String, dynamic>{'target': target},
      );
      Logger.info('[migrate] backup written to $target');
    } finally {
      await driver.close();
    }
  }
}
