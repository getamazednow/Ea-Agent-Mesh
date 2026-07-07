#!/usr/bin/env bash
# install-hooks.sh
#
# Wires pre-pr-check.sh as a local git pre-push hook, so it runs automatically before
# `git push` instead of relying on contributors to remember to run it manually.
#
# Usage: ./scripts/install-hooks.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK_DIR="$REPO_ROOT/.git/hooks"

if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "Not a git repository root: $REPO_ROOT" >&2
  exit 1
fi

mkdir -p "$HOOK_DIR"
cat > "$HOOK_DIR/pre-push" <<HOOK
#!/usr/bin/env bash
# Installed by scripts/install-hooks.sh — runs pre-pr-check.sh before every push.
"$SCRIPT_DIR/pre-pr-check.sh" || {
  echo "pre-push hook: pre-pr-check.sh failed. Fix issues above, or bypass with 'git push --no-verify' (not recommended for artefact changes)."
  exit 1
}
HOOK
chmod +x "$HOOK_DIR/pre-push"
echo "Installed pre-push hook at $HOOK_DIR/pre-push"
