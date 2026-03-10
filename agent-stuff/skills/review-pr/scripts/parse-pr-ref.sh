#!/usr/bin/env bash
# Parse a PR reference into repo and PR number.
#
# Input formats:
#   (no args)                        → auto-detect PR for current branch
#   123                              → {"repo":"","pr_id":"123"}
#   owner/repo#123                   → {"repo":"owner/repo","pr_id":"123"}
#   https://github.com/o/r/pull/123  → {"repo":"o/r","pr_id":"123"}
#
# Output: JSON with "repo", "pr_id", "repo_flag", and "branch" fields.
# If repo is empty, gh CLI will infer from current git remote.
set -euo pipefail

REPO=""
PR_ID=""
BRANCH=""

if [ $# -eq 0 ] || [ -z "$1" ]; then
  # Auto-detect: find PR associated with current branch
  BRANCH=$(git branch --show-current 2>/dev/null || true)
  if [ -z "$BRANCH" ]; then
    echo "Error: not on a branch (detached HEAD) and no PR_REF provided." >&2
    exit 1
  fi

  # gh pr view (no args) looks up PR for current branch
  PR_JSON=$(gh pr view --json number,state,url 2>/dev/null || true)
  if [ -z "$PR_JSON" ] || echo "$PR_JSON" | grep -q '"number":0'; then
    echo "Error: no PR found for current branch '$BRANCH'." >&2
    echo "Hint: create a PR first, or specify a PR reference explicitly." >&2
    exit 1
  fi

  PR_ID=$(echo "$PR_JSON" | sed -n 's/.*"number":\([0-9]*\).*/\1/p')
  PR_STATE=$(echo "$PR_JSON" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p')
  PR_URL=$(echo "$PR_JSON" | sed -n 's/.*"url":"\([^"]*\)".*/\1/p')

  echo "Auto-detected PR #${PR_ID} (${PR_STATE}) for branch '${BRANCH}'" >&2
  echo "  ${PR_URL}" >&2
else
  REF="$1"

  if [[ "$REF" =~ ^https?://github\.com/([^/]+/[^/]+)/pull/([0-9]+) ]]; then
    # GitHub URL
    REPO="${BASH_REMATCH[1]}"
    PR_ID="${BASH_REMATCH[2]}"
  elif [[ "$REF" =~ ^([^#]+/[^#]+)#([0-9]+)$ ]]; then
    # owner/repo#123
    REPO="${BASH_REMATCH[1]}"
    PR_ID="${BASH_REMATCH[2]}"
  elif [[ "$REF" =~ ^[0-9]+$ ]]; then
    # Plain number
    PR_ID="$REF"
  else
    echo "Error: unrecognized PR reference format: $REF" >&2
    echo "Expected: (empty), 123, owner/repo#123, or https://github.com/owner/repo/pull/123" >&2
    exit 1
  fi
fi

# Build repo flag for gh commands
REPO_FLAG=""
if [ -n "$REPO" ]; then
  REPO_FLAG="--repo $REPO"
fi

cat <<EOF
{"repo":"${REPO}","pr_id":"${PR_ID}","repo_flag":"${REPO_FLAG}","branch":"${BRANCH}"}
EOF
