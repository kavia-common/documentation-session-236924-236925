#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="${WORKSPACE:-/tmp/kavia/workspace/code-generation/documentation-session-236924-236925/Documentation}"
cd "$WORKSPACE"
PIP_CMD="python3 -m pip"
if [ "${INSTALL_SPELLCHECK:-false}" != "true" ]; then
  exit 0
fi
# choose candidates (allow explicit package override)
if [ -n "${SPELLCHECK_PKG:-}" ]; then
  candidates=("${SPELLCHECK_PKG}")
else
  candidates=(mkdocs-spelling mkdocs-spellcheck mkdocs-spellcheck-plugin)
fi
for pkg in "${candidates[@]}"; do
  if $PIP_CMD show "$pkg" >/dev/null 2>&1; then
    INST_VER="$($PIP_CMD show "$pkg" 2>/dev/null | awk -F": " '/^Version:/{print $2;exit}')"
    if [ -n "${SPELLCHECK_VERSION:-}" ]; then
      if [ "$INST_VER" = "${SPELLCHECK_VERSION}" ]; then
        exit 0
      fi
      # upgrade to requested exact version
      if $PIP_CMD install --upgrade --quiet "${pkg}==${SPELLCHECK_VERSION}" >/dev/null 2>&1; then
        exit 0
      else
        continue
      fi
    else
      # package installed and no specific version requested
      exit 0
    fi
  else
    if [ -n "${SPELLCHECK_VERSION:-}" ]; then
      if $PIP_CMD install --upgrade --quiet "${pkg}==${SPELLCHECK_VERSION}" >/dev/null 2>&1; then
        exit 0
      else
        continue
      fi
    else
      if $PIP_CMD install --upgrade --quiet "$pkg" >/dev/null 2>&1; then
        exit 0
      else
        continue
      fi
    fi
  fi
done
echo "spellcheck plugin installation failed for candidates: ${candidates[*]}" >&2
exit 7
