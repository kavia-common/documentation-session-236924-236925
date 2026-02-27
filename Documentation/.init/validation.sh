#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
cd "$WORKSPACE"
# ensure environment visible
if [ -d /etc/profile.d ]; then for f in /etc/profile.d/99-mkdocs-config-* /etc/profile.d/99-python-user-bin-* 2>/dev/null; do [ -f "$f" ] && source "$f" || true; done; fi
SITE_DIR="${SITE_DIR:-site}"
PORT="${PORT:-8001}"
BIND="${BIND:-0.0.0.0}"
# Run build
bash .init/build.sh || { echo "validation: build failed" >&2; exit 7; }
# Start server
bash .init/start.sh || { echo "validation: start failed" >&2; exit 8; }
# extract PID from generated pid files
PID=""
for p in /tmp/mkdocs-http-pid-*.pid; do [ -f "$p" ] || continue; PID=$(cat "$p" 2>/dev/null || true); [ -n "$PID" ] && break; done
# Run test (retries)
bash .init/test.sh || { echo "validation: test failed" >&2; # attempt to stop
  [ -n "$PID" ] && kill "$PID" || true; wait "$PID" 2>/dev/null || true; exit 9; }
# Stop server
if [ -n "$PID" ]; then bash .init/stop.sh || true; fi
echo "validation: site built at $WORKSPACE/$SITE_DIR and served successfully (index reachable)"
