// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// A shopping list per group. `done_at` is set when an item is bought.
/// Only creates a new table, so nothing is rebuilt.
///
/// A database the Bun API migrated already has the table. It is kept.
class ShoppingItems extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('shopping_items')) return;
    await schema.create('shopping_items', (Table table) {
      table.increments('id');
      table.integer('group_id').index();
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      table.string('name', 200);
      table.timestamp('done_at').nullable();
      table.integer('created_by_user_id').nullable();
      table
          .foreign('created_by_user_id')
          .references('id')
          .on('users')
          .onDelete('set null');
      table.timestamp('created_at');
      table.timestamp('updated_at');
    });
  }

  /// Never drop it: groups would lose their lists.
  @override
  Future<void> down(Schema schema) async {}
}
