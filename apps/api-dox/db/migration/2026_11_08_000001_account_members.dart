// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// People a wallet is shared with. The owner stays in `accounts.user_id`.
/// `user_id` is null while the invite is pending. Only creates a new
/// table, so nothing is rebuilt.
///
/// A database the Bun API migrated already has the table. It is kept.
class AccountMembers extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('account_members')) return;
    await schema.create('account_members', (Table table) {
      table.increments('id');
      table.integer('account_id');
      table
          .foreign('account_id')
          .references('id')
          .on('accounts')
          .onDelete('cascade');
      table.integer('user_id').nullable().index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      table.string('email', 254).index();
      table.integer('invited_by_user_id').nullable();
      table
          .foreign('invited_by_user_id')
          .references('id')
          .on('users')
          .onDelete('set null');
      table.timestamp('joined_at').nullable();
      table.timestamp('created_at');
      table.timestamp('updated_at');
      table.unique(<String>['account_id', 'email']);
    });
  }

  /// Never drop it: wallets that are shared would lose their members.
  @override
  Future<void> down(Schema schema) async {}
}
