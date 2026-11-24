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
  # They download from GitHub, which sometimes answers 504: try 3 times.
  && for i in 1 2 3; do \
       dart build cli --target bin/server.dart --output build && break; \
       [ "$i" = 3 ] && exit 1; \
       echo "dart build failed, retry $i in 15s"; sleep 15; \
     done

# Lay out the final file tree. /tmp must be writable: big uploads are
# streamed to a temp file. uid 1000 owns storage: it matches the user of
# the old images, so existing volumes stay writable.
RUN mkdir -p /out/app/storage /out/tmp \
  && chmod 1777 /out/tmp \
  && cp -r build/bundle/bin build/bundle/lib /out/app/ \
  && chown -R 1000:1000 /out/app/storage


############################
# 3. Runtime image: the binary, its native libraries and the SPA
############################
# No OS: /runtime/ of the Dart image has glibc and the CA certificates,
# and that is all the binary needs (Dox native libraries 3.2.4 or newer).
# So there is no shell and no curl in the container. Dox handles SIGTERM
# itself, so it needs no tini.
FROM scratch AS runtime

COPY --from=api-builder /runtime/ /
COPY --from=api-builder /out/ /
# The binary loads its native libraries from ../lib, so bin/ and lib/ stay together.
COPY --from=web-builder /app/web/dist /app/public

WORKDIR /app
VOLUME /app/storage

ENV APP_ENV=production \
    TZ=UTC \
    HOST=0.0.0.0 \
    PORT=3333 \
    DB_PATH=/app/storage/db.sqlite3 \
    PUBLIC_DIR=/app/public \
    CACHE_DIR=/app/storage/cache
EXPOSE 3333

USER 1000:1000
# No HEALTHCHECK: a call every minute kept the server busy for nothing.
# GET /healthz still works if Coolify or a monitor wants to check it.

# The API runs pending migrations itself on start (a SQLite backup first).
CMD ["/app/bin/server"]
