# Migrations

- `dox make:migration create_posts_table` makes a Dart migration here and
  updates `migrations.dart`, the list the app imports. Do not edit that list.
- `dox migration:run`, `migration:rollback`, `migration:status` run them.
- `bin/server.dart` also runs them once at start.
- A `.sql` file with `-- up` and `-- down` parts works too. Keep both comments.

## Rules of this app

- Keep migrations portable: they run on SQLite and Postgres.
- **Never rebuild a SQLite table** (drop a column, `change()`, `foreign()` on an
  existing table) that other tables reference with `ON DELETE CASCADE`. A
  rebuild drops the old table, and the drop fires the cascade. Add new
  nullable columns and leave retired ones in place.
- The first two migrations adopt a database the Bun or Adonis API made: they
  skip tables that are already there. Do not change them.
