# Monthly Expense

A small expense tracker for you and the people you share money with.
Log expenses, track wallets in many currencies, keep a shopping list, and
let an AI assistant (over MCP) add expenses and read summaries for you.

- **Web app:** React + Vite + shadcn/ui
- **API:** Dart ([Dox](https://dartondox.dev) framework), SQLite or Postgres
- **Sign-in:** Firebase (Google)
- **AI:** an MCP server with OAuth sign-in

```
monthly-expense/
├── apps/
│   ├── api-dox/     # REST API + MCP server (see apps/api-dox/README.md)
│   └── web/         # React SPA (Vite, Tailwind v4, shadcn/ui, Rare UI)
├── Dockerfile       # one image: the SPA and the API
├── docker-compose.yml
├── dev.sh           # runs the API and the web app together
└── .github/workflows/api-dox.yml   # tests, then pushes the image to ghcr.io
```

## How it works

- The web app signs in with Firebase (Google). It keeps no session.
  Every API request sends the Firebase **ID token** as
  `Authorization: Bearer <token>`.
- The API checks the token with `firebase_admin_sdk` on every request. It
  finds the user, or makes one on the first sign-in.
- After the first Google sign-in, a user can add a **passkey** on the Me
  page. Then they can sign in with it. The API checks the passkey and gives
  a Firebase custom token, so the rest works the same.
- The web app has no Firebase config built in. It loads `/config.js` from
  the API, which makes it from the API env. So one image works with any
  Firebase project.
- The API serves the built web app too. Production is one container.

## What you need

- **Dart** 3.13+ for the API.
- **Bun** for the web app (`brew install oven-sh/bun/bun`).
- A **Firebase project** with the Google sign-in provider on. From it you need:
  - the **web app config** (`apiKey`, `projectId`, `appId`), and
  - a **service account** (Project settings → Service accounts → Generate key).

## Run it locally

```bash
# 1. API
cd apps/api-dox
cp .env.example .env       # fill in APP_KEY and FIREBASE_*, set PORT=3334
dart pub get
dart run bin/server.dart   # http://localhost:3334, runs migrations on start

# 2. Web app (in a second terminal)
cd apps/web
bun install
bun pm trust --all
bun run dev                # http://localhost:5173
```

Open <http://localhost:5173> and sign in with Google.

Or run both from the repo root: `./dev.sh`.

The web dev server sends `/api`, `/config.js` and `/mcp` to the API on
port 3334. So the web app needs no `.env`.

## Env vars

All env vars belong to the API. See [apps/api-dox/.env.example](apps/api-dox/.env.example)
for the full list. The main ones:

| Variable | What it is |
|---|---|
| `APP_KEY` | Exactly 32 characters. Signs MCP sessions. Keep it the same across deploys. `dox key:generate` makes one. |
| `APP_URL` | The public URL, like `https://expense.example.com`. MCP sign-in uses it. |
| `DATABASE_URL` | Empty: SQLite at `DB_PATH`. A `postgres://` URL: Postgres. |
| `ALLOWED_EMAILS` | Comma separated emails that may sign in. Empty: anyone. |
| `FIREBASE_PROJECT_ID` | Your Firebase project id. |
| `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` | From the service account JSON. Secret. |
| `FIREBASE_API_KEY`, `FIREBASE_APP_ID` | From the Firebase web app config. Sent to the browser. |
| `FIREBASE_AUTH_DOMAIN` | Optional. Default: `<project id>.firebaseapp.com`. |

## Self-host with Docker

The `Dockerfile` builds the web app, compiles the API to a native binary
(`dart build cli`), and puts both in a small Debian image. The binary runs
migrations on start.

```bash
cp apps/api-dox/.env.example .env   # fill in APP_KEY, APP_URL, FIREBASE_*
docker compose up -d --build
# → http://localhost:3333
```

Or use the published image: `ghcr.io/necessarylion/monthly-expense:latest`.

SQLite data is kept in the `expense-data` volume.

In the Firebase console, add your domain to **Authentication → Settings →
Authorized domains**. If you don't, Google sign-in fails on your domain.

## REST API

The routes are under `/api/v1`. All of them need
`Authorization: Bearer <firebase-id-token>`. Group routes (categories,
expenses, summary, shopping list) also need an `X-Group-Id` header.

- Me, groups, members and budgets
- Categories, expenses, frequent expenses and the monthly summary
- Wallets (`/accounts`): entries, transfers, members, totals and history
- Exchange rates (`/fx`) and the shopping list

The full list is in [apps/api-dox/lib/routes/api.dart](apps/api-dox/lib/routes/api.dart).

### OpenAPI docs

The API serves OpenAPI docs when `APP_ENV=development`. They are off in
production. With the local API on port 3334:

| URL | What it is |
|---|---|
| <http://localhost:3334/docs> | Docs page (Scalar): every route, grouped by tag |
| <http://localhost:3334/openapi.json> | OpenAPI spec as JSON |
| <http://localhost:3334/openapi.yaml> | OpenAPI spec as YAML |

The titles and texts come from `@Summary`, `@Description` and `@Tags` on
the controller methods. Run `dart run build_runner build` after you change them.

Money is sent as decimals (`12.50`) and stored as integer cents.

## MCP (use with Claude)

The MCP endpoint is `{APP_URL}/mcp`. Clients sign in with OAuth: they open
the web app's consent page, and you approve them there. You can sign
clients out on the **Me** page.

There are 44 tools, one for each thing the HTTP API can do. Each tool takes
the same input as its HTTP route, plus the ids that HTTP takes from the
URL, like `groupId` or `accountId`. Start with `list_groups` to find a
`groupId`.

Add `https://your-host/mcp` as a custom connector on claude.ai, or with
Claude Code:

```bash
claude mcp add --transport http monthly-expense "https://your-host/mcp"
```

Then ask things like:

- "Add a $4.50 coffee under Food for today."
- "What did I spend on transport this month?"
- "Give me the May 2026 summary."

## CI

[api-dox.yml](.github/workflows/api-dox.yml) runs the API tests on SQLite
and Postgres. On every push to `main`, it builds the image and pushes it to
`ghcr.io/<owner>/<repo>`. The build needs no secrets.

To deploy after the push, set the `COOLIFY_DEPLOY_URL` variable and the
`COOLIFY_DEPLOY_TOKEN` secret. CI then calls the Coolify deploy webhook.
Without them, CI skips the deploy step.

## Credits

The web UI uses [shadcn/ui](https://ui.shadcn.com) and components from
[Rare UI](https://rareui.com) (MIT + Commons Clause + Attribution).

## License

[MIT](LICENSE). Rare UI files keep their own license (see Credits).
