// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// `api_tokens` is not used any more: the tokens are in
/// `auth_access_tokens` (dox_auth). No other table points at it, so the
/// drop rebuilds nothing and deletes nothing else.
class DropApiTokensTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    await schema.dropIfExists('api_tokens');
  }

  /// Nothing to bring back: no code reads the table, and the old tokens
  /// are gone.
  @override
  Future<void> down(Schema schema) async {}
}
