// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// Adds two nullable columns:
/// - `categories.budget_cents`: a monthly budget for one category.
/// - `expenses.paid_by_user_id`: who paid, when it is not the person who
///   logged it. Null means the creator paid.
///
/// Both tables are referenced by other tables. A plain nullable column with
/// no foreign key is an `ALTER TABLE ADD COLUMN` on SQLite, so no table is
/// rebuilt and no cascade fires. Do not add a foreign key here.
class AddBudgetsAndPayers extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (!await schema.hasColumn('categories', 'budget_cents')) {
      await schema.table('categories', (Table table) {
        table.bigInteger('budget_cents').nullable();
      });
    }
    if (!await schema.hasColumn('expenses', 'paid_by_user_id')) {
      await schema.table('expenses', (Table table) {
        table.integer('paid_by_user_id').nullable();
      });
    }
  }

  /// Never drop them: a drop rebuilds the table on SQLite.
  @override
  Future<void> down(Schema schema) async {}
}
