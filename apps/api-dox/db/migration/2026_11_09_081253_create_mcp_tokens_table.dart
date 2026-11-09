// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// One row per MCP client that signed in with OAuth. Only the SHA-256 of
/// the token is kept. Deleting a row signs that client out. A new table
/// only, so nothing is rebuilt.
///
/// `users.mcp_token` (the old token in the URL) is not used any more. It
/// stays: never drop a column on a table that others reference.
class CreateMcpTokensTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('mcp_tokens')) return;
    await schema.create('mcp_tokens', (Table table) {
      table.increments('id');
      table.integer('user_id').index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      table.string('name', 200);
      table.string('token_hash', 64).unique();
      table.timestamp('last_used_at').nullable();
      table.timestamp('created_at');
      table.timestamp('updated_at');
    });
  }

  /// No other table points at it, so dropping it rebuilds nothing. It signs
  /// every MCP client out.
  @override
  Future<void> down(Schema schema) async {
    await schema.dropIfExists('mcp_tokens');
  }
}
