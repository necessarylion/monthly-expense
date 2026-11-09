# api-dox

The monthly-expense API on the [Dox](https://dartondox.dev) framework (Dart).
It took over from the old Bun API, with the same JSON on the same routes.

## Commands

```bash
dart pub get
dart run bin/server.dart          # dev server (JIT). Reads .env
dart test --concurrency=1         # SQLite (.env.testing)
DATABASE_URL=postgres://... dart test --concurrency=1   # same tests on Postgres (wipes its public schema)
dart analyze --fatal-infos
dart format lib test bin db
dart run build_runner build       # after adding an @Inject class or an env key
dox build                         # AOT bundle in build/bundle (bin/server + lib/*.so)
dart run bin/migrate.dart status  # migrations only (the server also runs them on start)
```

Local `.env`:

```bash
APP_ENV=development
APP_KEY=<32 characters>           # dox key:generate
PORT=3333
DB_PATH=storage/db.sqlite3
FIREBASE_PROJECT_ID=...
FIREBASE_CLIENT_EMAIL=...
FIREBASE_PRIVATE_KEY=...
```

`dox_mcp` comes from pub.dev (source: `github.com/dartondox/dox-mcp`). To work on it next to this app, add a gitignored
`pubspec_overrides.yaml` with `dependency_overrides: {dox_mcp: {path: ../../../dox-mcp}}`.

## Stack

- HTTP: Dox (`dox_core`) on its native server, one isolate per CPU core. Routes in `lib/routes`, controllers in `lib/app/http/controllers`, middleware in `lib/app/http/middleware`, services in `lib/app/services`, repositories in `lib/app/repositories`.
- DB: `dox_orm` models, one per table (`lib/app/models/<name>/<name>.model.dart`). Timestamps and dates are text fields with the `TimestampText` and `DateText` casts (`lib/app/models/casts.dart`), so the built-in `DateTime` timestamps are off. Sums and counts use `QueryBuilder.table`. SQLite by default, Postgres when `DATABASE_URL=postgres://...`.
- Migrations: `dox_migration`, Dart files in `db/migration`, listed in `migrations.dart`. They run on server start, with a SQLite backup first.
- Cache: the Dox cache (`file` store in `CACHE_DIR`), for exchange rates.
- Validation: `@Dto` classes in `lib/app/dtos`, asked for as controller arguments (path params are typed args like `int id`). Body DTOs use `keyCase: KeyCase.field` (camelCase JSON) and `emptyStringsToNull: true` (`""` is `null`, so `note: ""` clears a note). Query numbers use `@OrDefault()`, so a bad value falls back to the default. Bad input is `422 { message, errors: [{ field, message, rule }] }`, built in `AppExceptionHandler` (`lib/app/exception_handler.dart`).
- DI: Dox container. Classes have `@Inject()`; `dart run build_runner build` writes `lib/generated/container.g.dart`.
- Auth: `firebase_admin_sdk` (the official Dart Admin SDK) checks the ID token in `FirebaseService`.
- MCP: `dox_mcp` at `/mcp`. Clients sign in with OAuth (`McpOAuth` of `dox_mcp`): the consent page is the web app's `/oauth/authorize`, the tokens are rows of `mcp_tokens` (hash only). Tools are in `lib/app/mcp/tools`.
- API docs: `/docs` (Scalar), `/openapi.json`, `/openapi.yaml`, made by `dart run build_runner build`. On only when `APP_ENV=development`. Config in `lib/config/openapi.dart`.
- Layers: route → controller → service → repository → model.

## Rules

- **Do not change the JSON.** The serializers in `lib/app/serializers` build every response; `test/serializer_test.dart` checks the exact JSON. Do not rename fields.
- **Keep queries portable.** No SQLite-only or Postgres-only SQL in repositories. Rows are read through the models (casts give bool, int and date text on both databases). Aggregate values go through `DbRow.toInt`.
- **Dates are text**: `YYYY-MM-DD` for dates, `YYYY-MM-DD HH:MM:SS` (UTC) for timestamps. Write them as strings, never as `DateTime` (the drivers would store ISO text with a `T`, and text comparisons would break).
- **SQLite: never rebuild a table** (drop column, change type) that other tables reference with `ON DELETE CASCADE`.
- **Each isolate has its own memory.** Do not keep state in a singleton that other isolates need. Shared state goes to the database or a file (the FX cache is a file). MCP sessions are signed ids, so any isolate can check them.
- **Outgoing HTTP calls need a timeout** (`HttpFetch`, `FirebaseService`).
- **Money is integer cents.** `MoneyUtil.toCents` rounds like JavaScript's `Math.round`.

## Tests

`dart test --concurrency=1` runs on a real HTTP server (`DoxTestClient`), with a fake Firebase and fake rate providers:

- `test/http_test.dart`: the HTTP contract (auth, groups, expenses, wallets, invites, CORS, SPA fallback, MCP, adjustments, frequent expenses, balance history).
- `test/account_share_test.dart`, `test/account_balance_test.dart`, `test/fx_test.dart`: shared wallets, balances and FX math.
- `test/adoption_test.dart`: `test/fixtures/bun_api.sqlite3` was written by the Bun API itself. The test checks that the migrations adopt it (with a backup), and that every row reads back the same.

CI (`.github/workflows/api-dox.yml`) runs them on SQLite and Postgres, and checks that the AOT binary starts.
