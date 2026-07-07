#!/usr/bin/env bash
# pre-pr-check.sh
#
# PRE-PR check. Run this locally before opening a pull request (or install it as a
# pre-push git hook via scripts/install-hooks.sh). It enforces, before a human reviewer
# ever sees the PR, the things GOVERNANCE.md says every artefact change must carry:
#
#   1. Provenance — any commit touching artefacts/** must state its data source, the
#      policy/principle version applied, and the prior decision it builds on. A PR
#      description doesn't exist yet at pre-push time, so this scans your commit messages.
#   2. Reviewer preview — tells you which CODEOWNERS group(s) will be required to
#      approve, based on the paths you've touched, so there are no surprises.
#   3. Tests — runs the configured test command if one is found.
#
# Exit code is non-zero if any required check fails.
#
# Usage:
#   ./scripts/pre-pr-check.sh [base-branch]      # default base branch: repo default_branch
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/config/repo-governance.yml"
READ="$SCRIPT_DIR/lib/read_config.py"
FAIL=0

command -v python3 >/dev/null 2>&1 || { echo "python3 is required"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "PyYAML is required: pip install pyyaml"; exit 1; }

DEFAULT_BRANCH="$(python3 "$READ" "$CONFIG_FILE" repo.default_branch 2>/dev/null || echo main)"
BASE_BRANCH="${1:-$DEFAULT_BRANCH}"
ARTEFACT_PREFIX="$(python3 "$READ" "$CONFIG_FILE" pre_pr_checks.artefact_path_prefix 2>/dev/null || echo artefacts/)"
REQUIRE_PROVENANCE="$(python3 "$READ" "$CONFIG_FILE" pre_pr_checks.require_provenance 2>/dev/null || echo true)"
RUN_TESTS="$(python3 "$READ" "$CONFIG_FILE" pre_pr_checks.run_tests 2>/dev/null || echo true)"
TEST_CMD="$(python3 "$READ" "$CONFIG_FILE" pre_pr_checks.test_command 2>/dev/null || echo "")"

# Resolve a comparison point. Prefer origin/<base>, fall back to local <base>, fall back to
# the first commit (so this still runs sensibly on a fresh repo with no remote yet).
MERGE_BASE=""
for ref in "origin/$BASE_BRANCH" "$BASE_BRANCH"; do
  if git rev-parse --verify -q "$ref" >/dev/null; then
    MERGE_BASE="$(git merge-base "$ref" HEAD 2>/dev/null || true)"
    [[ -n "$MERGE_BASE" ]] && break
  fi
done
if [[ -z "$MERGE_BASE" ]]; then
  MERGE_BASE="$(git rev-list --max-parents=0 HEAD | tail -1)"
  echo "note: no '$BASE_BRANCH' ref found locally; comparing against repo root commit."
fi

CHANGED_FILES="$(git diff --name-only "$MERGE_BASE" HEAD 2>/dev/null)"
if [[ -z "$CHANGED_FILES" ]]; then
  echo "No committed changes found ahead of $BASE_BRANCH — nothing to check yet."
fi

echo "== 1. Provenance check =="
ARTEFACT_CHANGES="$(echo "$CHANGED_FILES" | grep "^${ARTEFACT_PREFIX}" || true)"
if [[ -n "$ARTEFACT_CHANGES" && "$REQUIRE_PROVENANCE" == "True" || "$REQUIRE_PROVENANCE" == "true" ]] && [[ -n "$ARTEFACT_CHANGES" ]]; then
  echo "Artefact paths changed:"
  echo "$ARTEFACT_CHANGES" | sed 's/^/  - /'
  COMMIT_MSGS="$(git log "$MERGE_BASE"..HEAD --pretty=format:'%B')"
  MARKERS_JSON="$(python3 "$READ" "$CONFIG_FILE" pre_pr_checks.provenance_markers)"
  MISSING_MARKERS=()
  while IFS= read -r marker; do
    [[ -z "$marker" ]] && continue
    if ! grep -qF "$marker" <<< "$COMMIT_MSGS"; then
      MISSING_MARKERS+=("$marker")
    fi
  done < <(echo "$MARKERS_JSON" | python3 -c 'import json,sys; print("\n".join(json.load(sys.stdin)))')

  if [[ ${#MISSING_MARKERS[@]} -gt 0 ]]; then
    echo "FAIL: commit messages since $BASE_BRANCH are missing required provenance fields:"
    printf '    %s\n' "${MISSING_MARKERS[@]}"
    echo "  Add these to a commit message (or the eventual PR description), e.g.:"
    echo "    Data source: CMDB export 2026-07-07"
    echo "    Policy version: principles-v3.2"
    echo "    Prior decision: PR #142"
    FAIL=1
  else
    echo "OK: all required provenance fields present in commit history."
  fi
else
  echo "No artefacts/ changes detected — provenance check not applicable."
fi

echo
echo "== 2. Required reviewers preview (from CODEOWNERS) =="
CODEOWNERS_FILE="$REPO_ROOT/CODEOWNERS"
if [[ -f "$CODEOWNERS_FILE" && -n "$CHANGED_FILES" ]]; then
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    match="$(awk -v f="/$f" '
      $0 !~ /^#/ && NF {
        path=$1
        gsub(/\*$/,"",path)
        if (index(f, path) == 1) { $1=""; print substr($0, index($0,$2)) }
      }' "$CODEOWNERS_FILE" | tail -1)"
    if [[ -n "$match" ]]; then
      echo "  $f -> reviewers:$match"
    else
      echo "  $f -> falls to default CODEOWNERS rule"
    fi
  done <<< "$CHANGED_FILES"
else
  echo "No CODEOWNERS file or no changes to preview."
fi

echo
echo "== 3. Tests =="
NPM_CMD=false
[[ "$TEST_CMD" == npm* ]] && NPM_CMD=true
if [[ "$RUN_TESTS" == "True" || "$RUN_TESTS" == "true" ]]; then
  if [[ "$NPM_CMD" == true && ! -f "$REPO_ROOT/package.json" ]]; then
    echo "Skipped — no package.json at repo root yet (nothing to test until mesh/ code exists)."
  elif [[ -n "$TEST_CMD" ]] && command -v "${TEST_CMD%% *}" >/dev/null 2>&1; then
    echo "Running: $TEST_CMD"
    if (cd "$REPO_ROOT" && eval "$TEST_CMD"); then
      echo "OK: tests passed."
    else
      echo "FAIL: test command exited non-zero."
      FAIL=1
    fi
  else
    echo "Skipped — test command '$TEST_CMD' not runnable in this environment (no package.json / binary found yet)."
  fi
else
  echo "Skipped — run_tests: false in config."
fi

echo
if [[ "$FAIL" -ne 0 ]]; then
  echo "== pre-pr-check FAILED — fix the above before opening a PR =="
  exit 1
fi
echo "== pre-pr-check passed — safe to open a PR =="
