// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// `groups.kind`: `monthly` (null reads as monthly) or `trip`. A trip has
/// one budget and no months: every expense counts.
///
/// Many tables reference `groups` with ON DELETE CASCADE. A plain nullable
/// column is an `ALTER TABLE ADD COLUMN` on SQLite, so nothing is rebuilt.
class AddKindToGroups extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasColumn('groups', 'kind')) return;
    await schema.table('groups', (Table table) {
      table.string('kind', 10).nullable();
    });
  }

  /// Never drop it: a drop rebuilds the table on SQLite.
  @override
  Future<void> down(Schema schema) async {}
}
