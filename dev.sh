#!/usr/bin/env bash
set -e

trap 'kill 0' EXIT INT TERM

(cd apps/api-dox && dart run bin/server.dart) &
(cd apps/web && bun run dev) &

wait
