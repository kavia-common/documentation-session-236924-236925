#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
SITE_DIR="${SITE_DIR:-site}"
PORT="${PORT:-8001}"
BIND="${BIND:-0.0.0.0}"
ATTEMPTS="${ATTEMPTS:-15}"
SLEEP="${SLEEP:-1}"
# Determine curl host for in-container access
CURL_HOST=127.0.0.1
if [ "$BIND" != "0.0.0.0" ]; then CURL_HOST="$BIND"; fi
URL="http://${CURL_HOST}:${PORT}/index.html"
for i in $(seq 1 "$ATTEMPTS"); do
  if curl -sSf -o /dev/null "$URL" 2>/dev/null; then
    echo "test: index.html reachable"
    exit 0
  fi
  if [ "$i" -eq "$ATTEMPTS" ]; then
    echo "test: server did not respond after $ATTEMPTS attempts" >&2
    # attempt to show http log(s)
    ls -1 /tmp/mkdocs-http-*.log 2>/dev/null || true
    for f in /tmp/mkdocs-http-*.log; do [ -f "$f" ] && tail -n 200 "$f" || true; done
    exit 7
  fi
  sleep "$SLEEP"
done
