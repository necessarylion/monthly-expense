// ignore_for_file: file_names
import 'package:dox_auth/dox_auth.dart';
import 'package:dox_migration/dox_migration.dart';

/// The `auth_access_tokens` table of dox_auth: one row per signed-in
/// browser. It takes the place of `api_tokens`, which the next migration drops.
/// A new table only, so nothing is rebuilt.
class CreateAccessTokensTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable(AccessTokenTables.defaultTable)) return;
    await AccessTokenTables.up(schema, usersTable: 'users');
  }

  /// No other table points at it. It signs every browser out.
  @override
  Future<void> down(Schema schema) async {
    await AccessTokenTables.down(schema);
  }
}
