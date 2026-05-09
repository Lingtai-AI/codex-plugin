#!/usr/bin/env bash
# Install the LingTai integration into Codex CLI.
#
# This places:
#   - skills/lingtai/  → ~/.codex/skills/lingtai/
#   - SessionStart hook → merged into ~/.codex/hooks.json
#
# Hooks are enabled by default in Codex CLI 0.129.0+. No feature flag needed.
#
# Usage:
#   ./install.sh                  # install
#   ./install.sh --uninstall      # remove
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SRC_DIR/skills/lingtai"
SKILL_DST="$CODEX_HOME/skills/lingtai"
HOOKS_SRC="$SRC_DIR/hooks/hooks.json"
HOOKS_DST="$CODEX_HOME/hooks.json"

uninstall() {
  echo "Removing $SKILL_DST"
  rm -rf "$SKILL_DST"
  echo "Note: SessionStart hook in $HOOKS_DST was not modified — edit it by hand if you want to remove the lingtai entry."
}

if [ "${1:-}" = "--uninstall" ]; then
  uninstall
  exit 0
fi

mkdir -p "$CODEX_HOME/skills"
echo "Installing skill: $SKILL_DST"
rm -rf "$SKILL_DST"
cp -r "$SKILL_SRC" "$SKILL_DST"

if [ ! -f "$HOOKS_DST" ]; then
  echo "Creating $HOOKS_DST"
  cp "$HOOKS_SRC" "$HOOKS_DST"
else
  if grep -q '"LingTai network detected' "$HOOKS_DST"; then
    echo "Hook already present in $HOOKS_DST — leaving as-is."
  else
    echo
    echo "An existing $HOOKS_DST was found. Manual merge required."
    echo "Add the SessionStart entry from $HOOKS_SRC into your existing hooks.json."
    echo
  fi
fi

echo
echo "Done. Hooks are enabled by default in Codex CLI 0.129.0+."
echo "Start a Codex CLI session in a directory with .lingtai/ to verify."
