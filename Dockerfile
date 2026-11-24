# syntax=docker/dockerfile:1.7
#
# The app image: the React SPA and the Dox API (apps/api-dox) in one.
# Settings come from env at run time: see apps/api-dox/.env.example.

ARG BUN_VERSION=1.4
ARG DART_VERSION=3.14

FROM oven/bun:${BUN_VERSION}-debian AS web-builder

WORKDIR /app/web
COPY apps/web/package.json apps/web/bun.lock* ./
RUN bun install --frozen-lockfile

COPY apps/web/ ./
RUN bun run build


FROM dart:${DART_VERSION} AS api-builder

WORKDIR /app/api
COPY apps/api-dox/pubspec.* ./
RUN dart pub get

COPY apps/api-dox/ ./
# `dox build` runs build_runner, then `dart build cli`. Its build hooks
# download from GitHub, which sometimes answers 504: try 3 times.
RUN dart pub get --offline \
  && dart pub global activate dox \
  && for i in 1 2 3; do \
       /root/.pub-cache/bin/dox build && break; \
       [ "$i" = 3 ] && exit 1; \
       echo "dox build failed, retry $i in 15s"; sleep 15; \
     done

# /tmp: big uploads are streamed to a temp file. storage: the file cache.
RUN mkdir -p /out/app/storage /out/tmp \
  && chmod 1777 /out/tmp \
  && cp -r build/bundle/bin build/bundle/lib /out/app/ \
  && chown -R 1000:1000 /out/app/storage


# /runtime/ of the Dart image has glibc and the CA certificates.
FROM scratch

COPY --from=api-builder /runtime/ /
COPY --from=api-builder /out/ /
COPY --from=web-builder /app/web/dist /app/public

WORKDIR /app
EXPOSE 3333
USER 1000:1000
CMD ["/app/bin/server"]
