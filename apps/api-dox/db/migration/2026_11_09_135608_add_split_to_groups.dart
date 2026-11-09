// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// `groups.split_enabled`: the group splits costs (who paid, settle up).
/// Off by default. Null reads as off.
///
/// Many tables reference `groups` with ON DELETE CASCADE. A plain nullable
/// column is an `ALTER TABLE ADD COLUMN` on SQLite, so nothing is rebuilt.
class AddSplitToGroups extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasColumn('groups', 'split_enabled')) return;
    await schema.table('groups', (Table table) {
      table.boolean('split_enabled').nullable();
    });
  }

  /// Never drop it: a drop rebuilds the table on SQLite.
  @override
  Future<void> down(Schema schema) async {}
}
