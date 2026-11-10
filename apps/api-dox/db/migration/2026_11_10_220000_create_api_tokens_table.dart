// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// One row per signed-in browser. The web app trades a Firebase ID token
/// for one of these once (`POST /auth/token`) and sends it on every call.
/// Only the SHA-256 of the token is kept; deleting a row signs that browser
/// out. A new table only, so nothing is rebuilt.
class CreateApiTokensTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('api_tokens')) return;
    await schema.create('api_tokens', (Table table) {
      table.increments('id');
      table.integer('user_id').index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      table.string('token_hash', 64).unique();
      // the browser's User-Agent, cut short
      table.string('name', 200);
      // this sign-in gave the two-step code (or used a passkey)
      table.boolean('second_factor');
      table.timestamp('last_used_at').nullable();
      table.timestamp('expires_at');
      table.timestamp('created_at');
      table.timestamp('updated_at');
    });
  }

  /// No other table points at it, so dropping it rebuilds nothing. It signs
  /// every browser out.
  @override
  Future<void> down(Schema schema) async {
    await schema.dropIfExists('api_tokens');
  }
}
