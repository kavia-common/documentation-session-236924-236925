#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
cd "$WORKSPACE"
SITE_DIR="${SITE_DIR:-site}"
BUILD_LOG="/tmp/mkdocs-build-$$.log"
if ! command -v mkdocs >/dev/null 2>&1; then echo "build: mkdocs not found on PATH" >&2; exit 2; fi
if [ -n "${MKDOCS_CONFIG:-}" ]; then
  mkdocs build --config-file "${MKDOCS_CONFIG}" --site-dir "$SITE_DIR" >"$BUILD_LOG" 2>&1 || { tail -n 200 "$BUILD_LOG" >&2; echo "build: mkdocs build failed" >&2; exit 3; }
else
  mkdocs build --site-dir "$SITE_DIR" >"$BUILD_LOG" 2>&1 || { tail -n 200 "$BUILD_LOG" >&2; echo "build: mkdocs build failed" >&2; exit 3; }
fi
[ -f "$WORKSPACE/$SITE_DIR/index.html" ] || { echo "build: index.html missing after build" >&2; exit 4; }
echo "build: site generated at $WORKSPACE/$SITE_DIR"
