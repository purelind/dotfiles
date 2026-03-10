#!/usr/bin/env bash
# Parse a PR reference into repo and PR number.
#
# Input formats:
#   123                              → {"repo":"","pr_id":"123"}
#   owner/repo#123                   → {"repo":"owner/repo","pr_id":"123"}
#   https://github.com/o/r/pull/123  → {"repo":"o/r","pr_id":"123"}
#
# Output: JSON with "repo" and "pr_id" fields.
# If repo is empty, gh CLI will infer from current git remote.
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: parse-pr-ref.sh <PR_REF>" >&2
  exit 1
fi

REF="$1"
REPO=""
PR_ID=""

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
  echo "Expected: 123, owner/repo#123, or https://github.com/owner/repo/pull/123" >&2
  exit 1
fi

# Build repo flag for gh commands
REPO_FLAG=""
if [ -n "$REPO" ]; then
  REPO_FLAG="--repo $REPO"
fi

cat <<EOF
{"repo":"${REPO}","pr_id":"${PR_ID}","repo_flag":"${REPO_FLAG}"}
EOF
