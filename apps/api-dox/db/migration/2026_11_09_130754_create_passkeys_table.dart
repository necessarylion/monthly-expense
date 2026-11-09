// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// One row per passkey a user added. A new table only, so nothing is
/// rebuilt.
class CreatePasskeysTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('passkeys')) return;
    await schema.create('passkeys', (Table table) {
      table.increments('id');
      table.integer('user_id').index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      // base64url of the credential id (WebAuthn allows up to 1023 bytes)
      table.string('credential_id', 1400).unique();
      // base64url of the SubjectPublicKeyInfo (P-256)
      table.string('public_key', 400);
      table.integer('sign_count');
      table.string('name', 200);
      table.timestamp('last_used_at').nullable();
      table.timestamp('created_at');
      table.timestamp('updated_at');
    });
  }

  /// No other table points at it, so dropping it rebuilds nothing.
  @override
  Future<void> down(Schema schema) async {
    await schema.dropIfExists('passkeys');
  }
}
