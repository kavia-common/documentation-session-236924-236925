#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
# Source profile.d to pick up MKDOCS_CONFIG/PATH if env step wrote them
if [ -d /etc/profile.d ]; then
  for f in /etc/profile.d/99-mkdocs-config-* /etc/profile.d/99-python-user-bin-*; do
    [ -f "$f" ] && source "$f" || true
  done
fi
mkdir -p "$WORKSPACE/docs" && cd "$WORKSPACE"
# Minimal content
cat > "$WORKSPACE/docs/index.md" <<'MD'
# Welcome

This is a minimal MkDocs site scaffolded for automated development validation.
MD
cat > "$WORKSPACE/mkdocs.yml" <<'YML'
site_name: Documentation
nav:
  - Home: index.md
YML
cat > "$WORKSPACE/.gitignore" <<'GIT'
site/
*.pyc
__pycache__/
.env
venv/
GIT
cat > "$WORKSPACE/README.md" <<'R'
# Documentation project

Use ./build.sh to build the site and ./serve.sh to serve locally. Set SITE_DIR or MKDOCS_CONFIG env vars to override defaults.
R
# Helper scripts accept overrides
cat > "$WORKSPACE/build.sh" <<'B'
#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
SITE_DIR="${SITE_DIR:-site}"
if [ -n "${MKDOCS_CONFIG:-}" ]; then mkdocs build --config-file "${MKDOCS_CONFIG}" --site-dir "$SITE_DIR"; else mkdocs build --site-dir "$SITE_DIR"; fi
B
cat > "$WORKSPACE/serve.sh" <<'S'
#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
SITE_DIR="${SITE_DIR:-site}"
PORT="${PORT:-8000}"
# serve the built site
python3 -m http.server "$PORT" --bind 0.0.0.0 --directory "${WORKSPACE}/${SITE_DIR}"
S
chmod +x "$WORKSPACE/build.sh" "$WORKSPACE/serve.sh"
# ensure mkdocs is available before finishing
if ! command -v mkdocs >/dev/null 2>&1; then echo "mkdocs not available; run env-001" >&2; exit 5; fi
# Optional git init and commit with local config to avoid relying on global config
if [ "${INIT_GIT:-false}" = "true" ] && [ ! -d "$WORKSPACE/.git" ]; then
  git -C "$WORKSPACE" init --quiet
  if [ -n "${GIT_AUTHOR_NAME:-}" ] && [ -n "${GIT_AUTHOR_EMAIL:-}" ]; then
    git -C "$WORKSPACE" config user.name "${GIT_AUTHOR_NAME}"
    git -C "$WORKSPACE" config user.email "${GIT_AUTHOR_EMAIL}"
  fi
  git -C "$WORKSPACE" add . && git -C "$WORKSPACE" commit -m "scaffold: initial mkdocs site" || { echo "git commit failed" >&2; exit 6; }
fi
exit 0
