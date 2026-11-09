// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// A trip's first day (`trip_start`, `YYYY-MM-DD`) and length in days
/// (`trip_days`), so Home can show a daily budget like a monthly group.
///
/// Many tables reference `groups` with ON DELETE CASCADE. Plain nullable
/// columns are `ALTER TABLE ADD COLUMN` on SQLite, so nothing is rebuilt.
class AddTripDatesToGroups extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (!await schema.hasColumn('groups', 'trip_start')) {
      await schema.table('groups', (Table table) {
        table.string('trip_start', 10).nullable();
      });
    }
    if (!await schema.hasColumn('groups', 'trip_days')) {
      await schema.table('groups', (Table table) {
        table.integer('trip_days').nullable();
      });
    }
  }

  /// Never drop them: a drop rebuilds the table on SQLite.
  @override
  Future<void> down(Schema schema) async {}
}
