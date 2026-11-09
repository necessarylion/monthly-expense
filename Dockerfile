# syntax=docker/dockerfile:1.7
#
# The app image: the React SPA and the Dox API (apps/api-dox) in one.
# CI (.github/workflows/api-dox.yml) builds it and pushes it from main as
# ghcr.io/<repo>. To try it:
#
#   docker build -t expense .
#
# Run-time settings:
# - APP_KEY (new, exactly 32 characters). It signs the MCP sessions and
#   OAuth client ids, so keep it the same across deploys.
# - APP_URL (the public https URL). MCP OAuth sign-in uses it as the issuer,
#   so it must be the address clients see. Without it, it is localhost.
# - FIREBASE_* (Admin and Web SDK). The SPA gets its Firebase config from
#   `/config.js` at run time, so the image has no Firebase project baked in.

ARG BUN_VERSION=1.4.4
ARG DART_VERSION=3.13.7

############################
# 1. Build the React SPA
############################
FROM oven/bun:${BUN_VERSION}-debian AS web-builder

WORKDIR /app/web
COPY apps/web/package.json apps/web/bun.lock* ./
RUN bun install --frozen-lockfile

COPY apps/web/ ./


RUN bun run build


############################
# 2. AOT-compile the Dox API
############################
FROM dart:${DART_VERSION} AS api-builder

WORKDIR /app/api
COPY apps/api-dox/pubspec.* ./
RUN dart pub get

COPY apps/api-dox/ ./
RUN dart pub get --offline \
  && dart run build_runner build --delete-conflicting-outputs \
  # `dart build cli` (not `dart compile exe`): it runs the build hooks
  # that bundle SQLite and the native HTTP and Postgres libraries.
  && dart build cli --target bin/server.dart --output build


############################
# 3. Runtime image: the binary, its native libraries and the SPA
############################
FROM debian:bookworm-slim AS runtime

# ca-certificates: outgoing HTTPS (Firebase keys, FX rates). curl: healthcheck.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tini curl \
    && rm -rf /var/lib/apt/lists/*

# uid 1000 matches the `node` user of the old image, so existing volumes stay writable.
RUN useradd --uid 1000 --create-home app \
    && mkdir -p /app/storage && chown -R app:app /app/storage

WORKDIR /app
# The binary loads its native libraries from ../lib, so keep bin/ and lib/ together.
COPY --from=api-builder /app/api/build/bundle/bin ./bin
COPY --from=api-builder /app/api/build/bundle/lib ./lib
COPY --from=web-builder /app/web/dist ./public

VOLUME /app/storage

ENV APP_ENV=production \
    TZ=UTC \
    HOST=0.0.0.0 \
    PORT=3333 \
    DB_PATH=/app/storage/db.sqlite3 \
    PUBLIC_DIR=/app/public \
    CACHE_DIR=/app/storage/cache
EXPOSE 3333

USER app
HEALTHCHECK --interval=1m --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fsS http://localhost:3333/healthz || exit 1

# The API runs pending migrations itself on start (a SQLite backup first).
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["./bin/server"]
