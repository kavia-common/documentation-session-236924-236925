#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
SITE_DIR="${SITE_DIR:-site}"
if [ -n "${MKDOCS_CONFIG:-}" ]; then mkdocs build --config-file "${MKDOCS_CONFIG}" --site-dir "$SITE_DIR"; else mkdocs build --site-dir "$SITE_DIR"; fi
