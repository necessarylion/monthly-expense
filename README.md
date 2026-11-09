# Monthly Expense

A small personal expense tracker. **React + Vite + shadcn/ui** on the front end,
**Dart (Dox framework) + SQLite (or Postgres)** on the back end, **Firebase (Google login)** for auth,
and an **MCP server** so an LLM can add expenses and read summaries for you.

```
monthly-expense/
├── apps/
│   ├── api-dox/     # Dox API (REST API + MCP server), see apps/api-dox/README.md
│   └── web/         # React SPA (Vite, Tailwind v4, shadcn/ui, Rare UI)
├── Dockerfile             # multi-stage build → single image
├── docker-compose.yml
└── .github/workflows/api-dox.yml   # tests, then publishes to ghcr.io
```

## Architecture

- The frontend signs in via the Firebase JS SDK (Google provider) and stores
  no session — every API request carries the Firebase **ID token** as
  `Authorization: Bearer <id-token>`.
- The backend verifies that token with `firebase_admin_sdk` on every request and
  resolves it to a local `users` row (created on first sight).
- The MCP endpoint is `/mcp`. Clients sign in with OAuth.
  See the [MCP](#mcp-use-with-claude) section.

## Prerequisites

- **Dart** 3.13+ for the API, and **Bun** (`brew install oven-sh/bun/bun`) for the web app.
- A **Firebase project** with the Google auth provider enabled. You need:
  - A web app config (apiKey, authDomain, projectId, appId) — for the SPA.
  - A service account JSON — for the API.

## Local development

```bash
# 1. Backend
cd apps/api-dox
cp .env.example .env       # fill in APP_KEY, FIREBASE_*; set PORT=3334
dart pub get
dart run bin/server.dart   # http://localhost:3334 (runs migrations on start)

# 2. Frontend (in a second terminal)
cd apps/web
cp .env.example .env       # fill in VITE_FIREBASE_*
bun install
bun pm trust --all
bun run dev                # http://localhost:5173
```

Then open <http://localhost:5173>, sign in with Google, and start logging
expenses.

Or run both at once from the repo root: `./dev.sh`.

### Backend env vars

See `apps/api-dox/.env.example` and `apps/api-dox/README.md`.

### Frontend env vars (`apps/web/.env`)

| Variable | Purpose |
|---|---|
| `VITE_API_URL` | API base — `http://localhost:3333/api/v1` in dev, `/api/v1` in prod |
| `VITE_FIREBASE_API_KEY` | Firebase Web SDK config |
| `VITE_FIREBASE_AUTH_DOMAIN` | Firebase Web SDK config |
| `VITE_FIREBASE_PROJECT_ID` | Firebase Web SDK config |
| `VITE_FIREBASE_APP_ID` | Firebase Web SDK config |

## REST API

All routes are prefixed `/api/v1` and require `Authorization: Bearer <firebase-id-token>`.

| Method | Path | Description |
|---|---|---|
| `GET` | `/me` | Current user profile |
| `GET` | `/categories` | All categories visible to the user (system defaults + custom) |
| `POST` | `/categories` | Create a custom category `{ name, iconKey, color }` |
| `DELETE` | `/categories/:id` | Delete a custom category |
| `GET` | `/expenses?month=YYYY-MM` | Expenses for a month (default: current) |
| `POST` | `/expenses` | Create `{ categoryId, amount, occurredOn, note? }` |
| `PATCH` | `/expenses/:id` | Partial update |
| `DELETE` | `/expenses/:id` | Delete |
| `GET` | `/summary?month=YYYY-MM` | Totals overall and per-category for a month |

Amounts are sent/received as **decimals in dollars** but stored as integer cents.

## MCP (use with Claude)

The MCP endpoint is `{APP_URL}/mcp`. Clients sign in with OAuth: they open
the web app's consent page, and you approve them there. You can sign
clients out on the **Me** page.

The API has 44 tools: one for each thing the HTTP API can do. That is me,
groups and their members, budgets, the default wallet, categories, expenses
(also frequent ones and the monthly summary), wallets (with members,
entries, transfers, totals and history), exchange rates and the shopping
list. Each tool takes the same input as its HTTP route (the same DTO,
camelCase keys), plus the ids that HTTP takes from the URL, like `groupId`
or `accountId`. Start with `list_groups` to find a `groupId`.

Add `https://your-host/mcp` as a custom connector on claude.ai, or with
Claude Code:

```bash
claude mcp add --transport http monthly-expense "https://your-host/mcp"
```

### 3. Try it

Ask Claude things like:

- "Add a $4.50 coffee under Food for today."
- "What did I spend on transport this month?"
- "Give me the May 2026 summary."

Claude will call `add_expense`, `monthly_summary`, etc. on your behalf. New
entries show up in the web app on next refresh.

## Production: Docker

The multi-stage `Dockerfile` builds the SPA, AOT-compiles the API
(`dart build cli`), and produces a small image with just the binary, its
native libraries and the SPA. The API serves the SPA from `public/` and runs migrations
on start.

```bash
cp .env.example .env       # fill in everything
docker compose up -d --build
# → http://localhost:3333
```

SQLite is persisted in the named volume `expense-data`.

## CI: publishing the image

`.github/workflows/api-dox.yml` runs the tests, then builds and pushes
`ghcr.io/<owner>/<repo>` on every push to `main`. Set these in the repo:

- **Secrets**: `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_APP_ID`
- **Variables**: `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`,
  `VITE_API_URL` (optional, defaults to `/api/v1`)

Firebase **Admin** secrets stay out of the image — they're set at runtime
via the compose env file.

After the image is pushed on `main`, CI calls the Coolify deploy webhook
(`COOLIFY_DEPLOY_URL` variable, `COOLIFY_DEPLOY_TOKEN` secret).

## Credits

The web UI uses [shadcn/ui](https://ui.shadcn.com) and components from
[Rare UI](https://rareui.com) (MIT + Commons Clause + Attribution).
