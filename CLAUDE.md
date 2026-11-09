# Project notes for Claude

Read this before changing code. It captures the non-obvious bits.

## Stack

- **Backend** (`apps/api-dox`): the Dox framework (Dart). `dox_orm` for the DB:
  SQLite by default, Postgres when `DATABASE_URL=postgres://...`. `@Dto`
  validation, Dox DI (`@Inject()`), `firebase_admin_sdk` for token checks,
  `dox_mcp` for MCP. Layers: route → controller → service → repository → model.
  Commands and rules: `apps/api-dox/README.md` and `apps/api-dox/AGENTS.md`.
- **Frontend** (`apps/web`): React 19 + Vite + TS, Zustand stores, Tailwind v4,
  shadcn/ui (Radix base, `components.json`) plus a few Rare UI components,
  `motion`, `vaul`, Firebase JS SDK, lucide-react. Plain SPA: no router, no
  PWA or service worker (removed; `main.tsx` keeps a one-off unregister for
  old installs).
- **Package manager** (web): **bun**.

## Auth model (don't add sessions)

- The frontend signs in via Firebase Google popup and stores nothing locally.
- Every API request carries the Firebase **ID token** as `Authorization: Bearer <token>`.
  `apps/web/src/lib/api.ts` attaches it from `getIdToken()` automatically.
- Passkeys: a signed-in user adds one on Me. The login page signs in with
  it: `PasskeyService` checks it (`webauthn.dart`, ES256 only) and returns a
  Firebase **custom token**; the web app calls `signInWithCustomToken`.
  After that it is a normal Firebase session. Accepted origins are
  `APP_URL` and `FRONTEND_URLS`; the rpId is the page host.
- `lib/app/http/middleware/auth.middleware.dart` checks the token and finds or
  makes the user. `group.middleware.dart` reads `X-Group-Id` and checks
  membership. Routes are in `lib/routes/api.dart`.
- The Firebase web config is not in the bundle. `index.html` loads
  `/config.js` (`ConfigController`) before the app, and `lib/firebase.ts`
  reads `window.__APP_CONFIG__`. The API makes it from `FIREBASE_PROJECT_ID`,
  `FIREBASE_API_KEY`, `FIREBASE_AUTH_DOMAIN` and `FIREBASE_APP_ID`. In dev,
  Vite proxies `/config.js` to the API. Do not add `VITE_FIREBASE_*` back.

## MCP

- The endpoint is `/mcp`. Clients sign in with OAuth (`McpOAuth` of `dox_mcp`).
  The consent page is the web app's `/oauth/authorize`. Tools are in
  `lib/app/mcp/tools`. See `apps/api-dox/README.md`.

## Live updates

- Socket.IO (`dox_socketio`) at `/socket.io/`, websocket only. The app
  sends its Firebase ID token in `auth.token`; each socket joins
  `user:<id>` (`lib/app/socket/live.namespace.dart`).
- After a write, a service calls `LiveService`, which sends `changed`
  `{topic, groupId?}` to the users who can see the data. The event has no
  data: `apps/web/src/lib/live.ts` reloads that store. Topic names are in
  `lib/constants/live.dart` and must match `live.ts`.
- New writes that others should see: call `LiveService` in the service,
  not the controller (MCP tools and jobs use the services too).
- Many isolates share events through dox_socketio's `IsolateAdapter`. No
  Redis. There is no pull to refresh; do not add it back.

## Data shape

- Money is **integer cents** in the DB. Convert at the edges with `MoneyUtil`.
- Dates are text: `YYYY-MM-DD` for dates, `YYYY-MM-DD HH:MM:SS` (UTC) for
  timestamps. Write them as strings, never as `DateTime`.
- Categories belong to a group. New groups get `DEFAULT_CATEGORIES`.
- JSON is camelCase. `lib/app/serializers` builds every response shape, and
  `test/serializer_test.dart` checks it. The web app depends on it, so do not
  rename fields.

## Database rules

- **Keep queries portable** (SQLite and Postgres). No dialect-only SQL in
  repositories.
- Migrations are Dart files in `db/migration`, listed in `migrations.dart`.
  They run on server start. On SQLite the migrator writes a backup first.
- The production DB was made by the old Bun API (and Adonis before it). The
  migrations adopt it as is; `test/adoption_test.dart` checks that.

## Frontend conventions

- Layout: `src/screens/` (one file per tab), `src/sheets/` (bottom sheets),
  `src/components/app/` (our shared parts), `src/components/ui/` (shadcn and
  Rare UI files, added with `bunx shadcn add`; edit them freely).
- Tabs (`useUi.tab`): Home (`home`: allowance, calendar, quick add, list),
  Wallet (`accounts`: the user calls accounts "wallets" in all UI text; code
  and API keep `accounts`), List (`list`: the shopping list), Me (`settings`:
  a settings list with drill-in pages, `useUi.settingsTab`; Rates is one of
  them). The middle bar button opens the expense sheet; it is not a tab.
- Home's quick-add chips come from `GET /expenses/frequent`; the wallet cards'
  trend lines from `GET /accounts/history?days=30`.
- Stores live in `src/stores/` (Zustand). `useAuth` owns the Firebase listener
  (`watch()` is called once in `main.tsx`). `useUi` holds tab and sheet state.
  The expenses store reloads itself when the active group changes.
- A 401 from the API dispatches a `window` event `auth:unauthorized` that
  `App.tsx` listens for and logs the user out.
- i18n is a tiny `t()` in `src/lib/i18n.ts` over `src/locales/{en,my}.ts`
  (vue-i18n syntax: `{name}` placeholders, `{'@'}` escapes). Components call
  `useT()` so they re-render when the language changes. Add every new key to both files.
- Theme: `light | dark | system` plus palette themes `pink | mint | ocean |
  lavender | midnight | forest`, stored in `localStorage['app:theme']`
  (`lib/theme.ts`). Each palette is a CSS class in `index.css`. `midnight`
  and `forest` are dark, so they also get `.dark`. A script in `index.html`
  sets the classes before first paint; keep its lists in sync with `theme.ts`.
- Every add/edit form is a `Sheet` (`components/app/sheet.tsx`): a floating vaul
  drawer whose height animates between views. Deletes inside sheets use Rare
  UI's `DeleteButton` (confirm in place); success shows a `toast`.
- Icons come from `lucide-react` mapped by `icon_key`. The `icon_key`
  strings match `DEFAULT_CATEGORIES`; new categories pick from `ICON_OPTIONS`.
- Colors are hex strings (`#rrggbb`); tints use `color-mix` (`lib/overview.ts`).
- **Rare UI license:** keep the copyright line at the top of each Rare UI file,
  and keep the Rare UI credit link in the README (the license needs a visible
  credit somewhere; the README is enough).

## What NOT to do

- **Never drop a column (or any table-rebuilding alter) on a SQLite table that
  other tables reference with `ON DELETE CASCADE`.** A rebuild is copy → DROP
  old table → rename, and the DROP fires the cascade on every child table.
  This wiped all `account_entries` once. Leave retired columns in place.
- Don't add sessions or an auth framework. Token verification is custom on purpose.
- Don't store the Firebase ID token anywhere; the SDK manages refresh.
- Outgoing HTTP calls need a timeout. A provider that never answers once hung
  every exchange-rate request.

## CI / Docker

- One image, multi-stage: builds the SPA → AOT-compiles the API (`dart build cli`)
  → small Debian runtime with the binary, its `lib/*.so` and `public/`.
- The binary runs migrations on start. No separate migrate command in compose.
- The image is `ghcr.io/<owner>/<repo>`. After it is pushed on `main`, CI
  calls the Coolify deploy webhook (skipped when `COOLIFY_DEPLOY_URL` is not set).
- The build needs no secrets. All env, Firebase included, is set at run
  time. The only env example is `apps/api-dox/.env.example`; compose reads
  a copy of it as `.env` in the repo root.
- The repo is public. Never commit `.env`, keys, real emails or server
  URLs. Use `example.com` style values in docs and tests.
