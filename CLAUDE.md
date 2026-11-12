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

## Auth model (API tokens; Firebase only at sign-in)

- The frontend signs in via Firebase (Google popup, or email and password),
  then trades the Firebase ID token for our own **API token** once:
  `POST /api/v1/auth/token` (`ApiTokenService.signIn`). Firebase is not
  checked again after that; this is what makes calls and cold starts fast.
  Right after the trade the app signs out of Firebase, and it loads the
  Firebase SDK only when there is no API token (the login screen).
- `FirebaseService.verifyIdToken` refuses a token whose email is not verified.
  Invites and `ALLOWED_EMAILS` trust the email, so do not remove this check.
  The login page sends the verify link and signs the user out until then.
- API tokens are random (`mea_` prefix), stored only as SHA-256 in
  `api_tokens`, one row per browser. Each lasts 30 days. Once a token is a
  day old the app trades it for a new one (`POST /auth/token/refresh`; the
  old one works 2 more minutes), so opening the app within 30 days keeps
  the user signed in. `DELETE /auth/token` (sign out) deletes the row. Every API request carries it as `Authorization: Bearer <token>`;
  `apps/web/src/lib/api.ts` attaches it from `lib/session.ts`.
- The web app keeps the API token and the last `/me` in `localStorage`
  (`lib/session.ts`), so a returning user loads at once without waiting for
  Firebase. Never store the Firebase ID token. A Firebase session with no
  API token (from before API tokens) is traded automatically.
- Passkeys: a signed-in user adds one on Me. The login page signs in with
  it: `PasskeyService` checks it (`webauthn.dart`, ES256 only) and returns
  an API token directly. Accepted origins are `APP_URL` and
  `FRONTEND_URLS`; the rpId is the page host.
- Two-step sign-in (TOTP) is ours, not Firebase MFA (that needs Identity
  Platform). An API token has a `second_factor` flag. `TotpService` checks
  the code and sets it on the caller's token (`/me/totp/verify`, and
  `/me/totp/enable` for the browser that turns it on). `TwoFactorMiddleware`
  (and the live socket) refuse a user who has it on when the token is not
  marked: 403 with `code: mfa_required`, and the web app shows the code
  form. A passkey token is marked, and so is one traded from a Firebase ID
  token with the old `mfa` claim. New routes go in the `user` group of
  `api.dart`, never in `signedIn`.
- `lib/app/http/middleware/auth.middleware.dart` looks up the API token and
  its user (the user is made at sign-in, in `ApiTokenService.signIn`). `group.middleware.dart` reads `X-Group-Id` and checks
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
  sends its API token in `auth.token`; each socket joins
  `user:<id>` (`lib/app/socket/live.namespace.dart`).
- After a write, a service calls `LiveService`, which sends `changed`
  `{topic, groupId?}` to the users who can see the data. The event has no
  data: `apps/web/src/lib/live.ts` reloads that store. Topic names are in
  `lib/constants/live.dart` and must match `live.ts`.
- New writes that others should see: call `LiveService` in the service,
  not the controller (MCP tools and jobs use the services too).
- Many isolates share events through dox_socketio's `IsolateAdapter`. No
  Redis. There is no pull to refresh; do not add it back.

## AI screens (A2UI)

- "Explain my month" (`MonthInsightService`) and smart add (`SmartAddService`)
  send A2UI v0.9 messages; the web app draws them with `@a2ui/react`
  (`components/app/a2ui-view.tsx`). The React renderer speaks v0.9 only.
- The Dart SDK's catalog is wider than the React one: `List` with
  `listStyle` is rejected by the renderer. Keep `insightComponents` to parts
  both accept, and test a new one in the browser.
- Claude writes the screen only when it is read-only. Smart add saves money,
  so Claude only reads the text (JSON) and `SmartAddScreen` draws the cards.
  A Save tap posts the A2UI action; its `context` is a `CreateExpense`.
- Cost: `ClaudeClient` marks the system prompt with `cache_control` (keep
  system prompts fixed text; no dates or ids in them). The month answer is
  kept in `FileCache` under a fingerprint of the prompt. AI routes share a
  per-user rate limit (`insightsPerMinute`).

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
- Add expense asks for no category; the note is required. The API finds the
  category (`ExpenseCategorizer`): the group's last expense with the same note,
  else Claude, after the answer is sent (a `changed` event updates the app).
  A new note on edit sorts it again. MCP and quick-add may still send `categoryId`.
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
- Add expense and add wallet transaction are full screen (`components/app/full-screen.tsx`):
  a back button, the fields, the amount, then a flat number pad and the save bar. No
  header and no tab bar. Every other add/edit form is a `Sheet` (`components/app/sheet.tsx`):
  a floating vaul drawer whose height animates between views. Deletes inside sheets use Rare
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
- Don't add an auth framework. API tokens (`ApiTokenService`) are custom on purpose.
- Don't store the Firebase ID token anywhere, and don't accept it on API
  routes: it is only for `POST /auth/token`.
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
