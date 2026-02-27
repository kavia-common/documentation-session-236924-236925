#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
SITE_DIR="${SITE_DIR:-site}"
PORT="${PORT:-8000}"
# serve the built site
python3 -m http.server "$PORT" --bind 0.0.0.0 --directory "${WORKSPACE}/${SITE_DIR}"
