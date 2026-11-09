// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// Expenses that repeat every month, like rent. The scheduler adds a real
/// expense on `next_on`, then moves `next_on` one month on. Only creates a
/// new table, so nothing is rebuilt.
class CreateRecurringExpensesTable extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await schema.hasTable('recurring_expenses')) return;
    await schema.create('recurring_expenses', (Table table) {
      table.increments('id');
      table.integer('group_id').index();
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      table.integer('created_by_user_id').nullable();
      table
          .foreign('created_by_user_id')
          .references('id')
          .on('users')
          .onDelete('set null');
      table.integer('category_id').nullable();
      table
          .foreign('category_id')
          .references('id')
          .on('categories')
          .onDelete('set null');
      // Null: the creator's default wallet at the time it runs.
      table.integer('account_id').nullable();
      table
          .foreign('account_id')
          .references('id')
          .on('accounts')
          .onDelete('set null');
      table.bigInteger('amount_cents');
      table.string('note', 500).nullable();
      // 1 to 31. A short month uses its last day.
      table.integer('day_of_month');
      table.date('next_on').index();
      table.timestamp('created_at');
      table.timestamp('updated_at');
    });
  }

  @override
  Future<void> down(Schema schema) async {
    await schema.dropIfExists('recurring_expenses');
  }
}
