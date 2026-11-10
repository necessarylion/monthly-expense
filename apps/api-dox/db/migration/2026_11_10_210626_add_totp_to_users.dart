// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// Two-step sign-in. `users.totp_secret` is the authenticator app's secret
/// (encrypted). `users.totp_enabled` is true once the user proved one code.
///
/// Many tables reference `users` with ON DELETE CASCADE. Plain nullable
/// columns are an `ALTER TABLE ADD COLUMN` on SQLite, so nothing is rebuilt.
class AddTotpToUsers extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (!await schema.hasColumn('users', 'totp_secret')) {
      await schema.table('users', (Table table) {
        table.text('totp_secret').nullable();
      });
    }
    if (!await schema.hasColumn('users', 'totp_enabled')) {
      await schema.table('users', (Table table) {
        table.boolean('totp_enabled').nullable();
      });
    }
  }

  /// Never drop them: a drop rebuilds the table on SQLite.
  @override
  Future<void> down(Schema schema) async {}
}
