#!/usr/bin/env bash
# Submit a code review to a GitHub PR.
#
# Usage:
#   submit-review.sh <PR_REF> --comment <body_file>
#   submit-review.sh <PR_REF> --review <review_json_file>
#
# Modes:
#   --comment <file>   Submit the file content as a single PR review comment.
#   --review  <file>   Submit a structured review with line-level comments.
#                       The JSON file format:
#                       {
#                         "body": "## Review Summary\n...",
#                         "event": "COMMENT",
#                         "comments": [
#                           {
#                             "path": "file/path.go",
#                             "line": 42,
#                             "body": "Issue description..."
#                           }
#                         ]
#                       }
#                       "event" can be: COMMENT, APPROVE, REQUEST_CHANGES
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ $# -lt 3 ]; then
  cat >&2 <<'USAGE'
Usage:
  submit-review.sh <PR_REF> --comment <body_file>
  submit-review.sh <PR_REF> --review  <review_json_file>
USAGE
  exit 1
fi

PR_REF="$1"
MODE="$2"
FILE="$3"

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# Parse PR reference
PARSED=$("$SCRIPT_DIR/parse-pr-ref.sh" "$PR_REF")
REPO=$(echo "$PARSED" | sed -n 's/.*"repo":"\([^"]*\)".*/\1/p')
PR_ID=$(echo "$PARSED" | sed -n 's/.*"pr_id":"\([^"]*\)".*/\1/p')

REPO_FLAG=""
if [ -n "$REPO" ]; then
  REPO_FLAG="--repo $REPO"
fi

case "$MODE" in
  --comment)
    BODY=$(cat "$FILE")
    # shellcheck disable=SC2086
    gh pr review "$PR_ID" $REPO_FLAG --comment --body "$BODY"
    echo "Review comment submitted to PR #${PR_ID}."
    ;;

  --review)
    # Determine owner/repo for API call
    if [ -n "$REPO" ]; then
      OWNER_REPO="$REPO"
    else
      OWNER_REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
    fi

    # Use gh api to submit review with line-level comments
    # The JSON file is passed directly as the request body
    gh api "repos/${OWNER_REPO}/pulls/${PR_ID}/reviews" \
      --method POST \
      --input "$FILE"
    echo "Structured review submitted to PR #${PR_ID}."
    ;;

  *)
    echo "Error: unknown mode '$MODE'. Use --comment or --review." >&2
    exit 1
    ;;
esac
