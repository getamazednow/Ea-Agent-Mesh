#!/usr/bin/env bash
# bootstrap-repo.sh
#
# POST-PUSH setup. Run this once after the initial `git push` of this repo (and again any
# time config/repo-governance.yml changes). It applies the governance model described in
# GOVERNANCE.md as real GitHub repo settings:
#   - branch protection on the default branch (required status checks, CODEOWNERS review)
#   - labels used by the issue templates and cadence tagging
#   - a check that every team referenced in CODEOWNERS actually exists
#
# It does NOT create teams or add people to them — team membership is a people decision,
# not a script decision. It tells you what's missing so you (or an org admin) can create it.
#
# Requires: GitHub CLI (`gh`), authenticated (`gh auth login`), with admin rights on the repo.
#
# Usage:
#   ./scripts/bootstrap-repo.sh [path/to/repo-governance.yml]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="${1:-$REPO_ROOT/config/repo-governance.yml}"
READ="$SCRIPT_DIR/lib/read_config.py"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config not found: $CONFIG_FILE" >&2
  exit 1
fi

command -v gh >/dev/null 2>&1 || { echo "GitHub CLI (gh) is required. Install: https://cli.github.com"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "python3 is required to parse $CONFIG_FILE"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "PyYAML is required: pip install pyyaml"; exit 1; }

gh auth status >/dev/null 2>&1 || { echo "Not authenticated. Run: gh auth login"; exit 1; }

OWNER="$(python3 "$READ" "$CONFIG_FILE" repo.owner)"
NAME="$(python3 "$READ" "$CONFIG_FILE" repo.name)"
DEFAULT_BRANCH="$(python3 "$READ" "$CONFIG_FILE" repo.default_branch)"
VISIBILITY="$(python3 "$READ" "$CONFIG_FILE" repo.visibility)"

if [[ "$OWNER" == "<github-org-or-user>" ]]; then
  echo "config/repo-governance.yml still has the placeholder repo.owner — edit it first." >&2
  exit 1
fi

REPO="$OWNER/$NAME"
echo "== Bootstrapping governance for $REPO (default branch: $DEFAULT_BRANCH) =="

echo
echo "-- Repo visibility --"
CURRENT_VIS="$(gh repo view "$REPO" --json visibility -q .visibility 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "unknown")"
if [[ "$CURRENT_VIS" != "$VISIBILITY" ]]; then
  echo "Current visibility: $CURRENT_VIS, config wants: $VISIBILITY"
  gh repo edit "$REPO" --visibility "$VISIBILITY" --accept-visibility-change-consequences || \
    echo "  (edit failed — you may lack permission)"
else
  echo "Visibility already '$VISIBILITY'. OK."
fi

echo
echo "-- Labels --"
LABELS_JSON="$(python3 "$READ" "$CONFIG_FILE" labels)"
echo "$LABELS_JSON" | python3 -c '
import json, sys
for l in json.load(sys.stdin):
    name = l["name"]
    color = l.get("color", "ededed")
    desc = l.get("description", "")
    print(f"{name}\t{color}\t{desc}")
' | while IFS=$'\t' read -r lname lcolor ldesc; do
  if gh label list --repo "$REPO" --json name -q '.[].name' | grep -qx "$lname"; then
    gh label edit "$lname" --repo "$REPO" --color "$lcolor" --description "$ldesc" >/dev/null
    echo "  updated: $lname"
  else
    gh label create "$lname" --repo "$REPO" --color "$lcolor" --description "$ldesc" >/dev/null
    echo "  created: $lname"
  fi
done

echo
echo "-- Teams referenced by CODEOWNERS --"
TEAM_SLUGS="$(python3 "$READ" "$CONFIG_FILE" teams | python3 -c 'import json,sys; print("\n".join(t["slug"] for t in json.load(sys.stdin)))')"
MISSING_TEAMS=()
while IFS= read -r slug; do
  [[ -z "$slug" ]] && continue
  if gh api "orgs/$OWNER/teams/$slug" >/dev/null 2>&1; then
    echo "  OK: @$OWNER/$slug exists"
  else
    echo "  MISSING: @$OWNER/$slug (either the repo is personal, not org-owned, or the team hasn't been created)"
    MISSING_TEAMS+=("$slug")
  fi
done <<< "$TEAM_SLUGS"

if [[ ${#MISSING_TEAMS[@]} -gt 0 ]]; then
  echo
  echo "  Action needed: create these teams (org admin) or replace their handles in CODEOWNERS"
  echo "  with real usernames if this repo is under a personal account, not an org:"
  printf '    - %s\n' "${MISSING_TEAMS[@]}"
fi

echo
echo "-- Branch protection on $DEFAULT_BRANCH --"
CONTEXTS_JSON="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_status_checks.contexts)"
STRICT="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_status_checks.strict)"
REQUIRE_CODEOWNERS="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_pull_request_reviews.require_code_owner_reviews)"
APPROVALS="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_pull_request_reviews.required_approving_review_count)"
DISMISS_STALE="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_pull_request_reviews.dismiss_stale_reviews)"
ENFORCE_ADMINS="$(python3 "$READ" "$CONFIG_FILE" branch_protection.enforce_admins)"
LINEAR_HISTORY="$(python3 "$READ" "$CONFIG_FILE" branch_protection.required_linear_history)"
ALLOW_FORCE="$(python3 "$READ" "$CONFIG_FILE" branch_protection.allow_force_pushes)"
ALLOW_DELETE="$(python3 "$READ" "$CONFIG_FILE" branch_protection.allow_deletions)"

PAYLOAD="$(python3 - "$CONTEXTS_JSON" "$STRICT" "$REQUIRE_CODEOWNERS" "$APPROVALS" "$DISMISS_STALE" "$ENFORCE_ADMINS" "$LINEAR_HISTORY" "$ALLOW_FORCE" "$ALLOW_DELETE" <<'PYEOF'
import json, sys
contexts = json.loads(sys.argv[1])
def b(v): return str(v).strip().lower() == "true"
payload = {
    "required_status_checks": {"strict": b(sys.argv[2]), "contexts": contexts},
    "enforce_admins": b(sys.argv[6]),
    "required_pull_request_reviews": {
        "require_code_owner_reviews": b(sys.argv[3]),
        "required_approving_review_count": int(sys.argv[4]),
        "dismiss_stale_reviews": b(sys.argv[5]),
    },
    "restrictions": None,
    "required_linear_history": b(sys.argv[7]),
    "allow_force_pushes": b(sys.argv[8]),
    "allow_deletions": b(sys.argv[9]),
}
print(json.dumps(payload))
PYEOF
)"

echo "$PAYLOAD" | gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  "repos/$REPO/branches/$DEFAULT_BRANCH/protection" \
  --input - >/dev/null \
  && echo "  Branch protection applied to $DEFAULT_BRANCH." \
  || echo "  Failed to apply branch protection — check you have admin rights on $REPO and that $DEFAULT_BRANCH exists on GitHub (push it first)."

echo
echo "== Done. Re-run any time config/repo-governance.yml changes. =="
