#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
cd "$WORKSPACE"
SITE_DIR="${SITE_DIR:-site}"
PORT="${PORT:-8001}"
BIND="${BIND:-0.0.0.0}"
HTTP_LOG="/tmp/mkdocs-http-$$.log"
if [ ! -d "$WORKSPACE/$SITE_DIR" ]; then echo "start: site directory $WORKSPACE/$SITE_DIR not found" >&2; exit 5; fi
nohup python3 -m http.server "$PORT" --bind "$BIND" --directory "$WORKSPACE/$SITE_DIR" >"$HTTP_LOG" 2>&1 &
PID=$!
# give short time for process to appear
sleep 0.5
if ! ps -p "$PID" >/dev/null 2>&1; then echo "start: server failed to start, see $HTTP_LOG" >&2; tail -n 200 "$HTTP_LOG" >&2 || true; exit 6; fi
# record pid file
echo "$PID" > "/tmp/mkdocs-http-pid-$$.pid"
echo "start: server started pid=$PID port=$PORT bind=$BIND log=$HTTP_LOG"
