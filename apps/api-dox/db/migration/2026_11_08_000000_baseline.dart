// ignore_for_file: file_names
import 'package:dox_migration/dox_migration.dart';

/// How many migrations the last Adonis release applied.
const int _adonisMigrationCount = 14;

/// The schema as the Adonis and Bun APIs left it. Column types work on
/// both SQLite and Postgres. Cents are bigint: a 1e9 budget is 1e11
/// cents, too big for a Postgres integer.
///
/// A database made by an older API is adopted as it is:
/// - the Adonis API left an `adonis_schema` table (SQLite only),
/// - the Bun API left the tables and a `kysely_migration` table.
/// In both cases the tables are already there, so nothing is created.
class Baseline extends Migration {
  @override
  Future<void> up(Schema schema) async {
    if (await _isAdonisDatabase(schema)) return;
    if (await schema.hasTable('users')) return;

    await schema.create('users', (Table table) {
      table.increments('id');
      table.string('firebase_uid').unique();
      table.string('email', 254);
      table.string('display_name').nullable();
      table.string('photo_url', 1024).nullable();
      table.string('mcp_token', 128).nullable().unique();
      _timestamps(table);
    });

    await schema.create('groups', (Table table) {
      table.increments('id');
      table.string('name', 80);
      table.string('currency', 3).defaultTo('USD');
      _userSetNull(table, 'created_by_user_id');
      _timestamps(table);
    });

    await schema.create('accounts', (Table table) {
      table.increments('id');
      table.integer('user_id').index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      table.string('name', 50);
      table.string('currency', 3);
      table.string('color', 7).defaultTo('#3b82f6');
      table.boolean('include_in_total').defaultTo(true);
      _timestamps(table);
    });

    await schema.create('group_members', (Table table) {
      table.increments('id');
      table.integer('group_id');
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      table.integer('user_id').nullable().index();
      table.foreign('user_id').references('id').on('users').onDelete('cascade');
      table.string('email', 254).index();
      _userSetNull(table, 'invited_by_user_id');
      table.timestamp('joined_at').nullable();
      table.integer('default_account_id').nullable();
      table
          .foreign('default_account_id')
          .references('id')
          .on('accounts')
          .onDelete('set null');
      _timestamps(table);
      table.unique(<String>['group_id', 'email']);
    });

    await schema.create('categories', (Table table) {
      table.increments('id');
      table.integer('group_id');
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      table.string('name');
      table.string('slug');
      table.string('icon_key');
      table.string('color');
      table.timestamp('created_at');
      table.unique(<String>['group_id', 'slug']);
    });

    await schema.create('expenses', (Table table) {
      table.increments('id');
      table.integer('group_id');
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      _userSetNull(table, 'created_by_user_id');
      table.integer('category_id').nullable();
      table
          .foreign('category_id')
          .references('id')
          .on('categories')
          .onDelete('set null');
      table.bigInteger('amount_cents');
      table.date('occurred_on');
      table.string('note', 500).nullable();
      _timestamps(table);
      table.index(<String>['group_id', 'occurred_on']);
    });

    await schema.create('group_monthly_budgets', (Table table) {
      table.increments('id');
      table.integer('group_id');
      table
          .foreign('group_id')
          .references('id')
          .on('groups')
          .onDelete('cascade');
      table.string('month_key', 7);
      table.bigInteger('budget_cents');
      _timestamps(table);
      table.unique(<String>['group_id', 'month_key']);
    });

    await schema.create('account_entries', (Table table) {
      table.increments('id');
      table.integer('account_id');
      table
          .foreign('account_id')
          .references('id')
          .on('accounts')
          .onDelete('cascade');
      table.integer('expense_id').nullable();
      table
          .foreign('expense_id')
          .references('id')
          .on('expenses')
          .onDelete('cascade');
      table.bigInteger('amount_cents');
      table.date('occurred_on');
      table.string('note', 500).nullable();
      _timestamps(table);
      table.index(<String>['account_id', 'occurred_on']);
    });
  }

  /// The baseline is the first schema. There is nothing older to go back to.
  @override
  Future<void> down(Schema schema) async {}

  /// A DB the old Adonis API made already has this schema. Leave it as it is.
  static Future<bool> _isAdonisDatabase(Schema schema) async {
    if (!await schema.hasTable('adonis_schema')) return false;
    List<Map<String, dynamic>> rows = await schema.driver.query(
      'SELECT count(*) AS n FROM adonis_schema',
    );
    int count = int.parse(rows.first['n'].toString());
    if (count != _adonisMigrationCount) {
      throw StateError(
        'Adonis DB has $count migrations, expected $_adonisMigrationCount. '
        'Run the old API migrations first.',
      );
    }
    return true;
  }

  static void _timestamps(Table table) {
    table.timestamp('created_at');
    table.timestamp('updated_at');
  }

  static void _userSetNull(Table table, String column) {
    table.integer(column).nullable();
    table.foreign(column).references('id').on('users').onDelete('set null');
  }
}
