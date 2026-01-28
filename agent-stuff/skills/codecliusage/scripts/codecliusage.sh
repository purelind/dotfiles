#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOL="claude"
ARGS=()

show_help() {
    cat <<'EOF'
Usage: codecliusage.sh [--tool claude|codex] [command] [options]

Query local Claude Code and Codex token usage and costs.

Tool Selection:
  --tool claude    Query Claude Code usage (default)
  --tool codex     Query OpenAI Codex usage

Commands:
  daily            Daily token usage and costs (default)
  monthly          Monthly aggregated report
  session          Usage by conversation session
  blocks           5-hour billing windows
  statusline       Compact status line for hooks (Beta)

Options:
  --since YYYYMMDD   Start date filter
  --until YYYYMMDD   End date filter
  --json             JSON output
  --breakdown        Per-model cost breakdown
  --compact          Force compact table layout
  --instances        Group by project/instance
  --project <name>   Filter to specific project
  --timezone <tz>    Timezone for date grouping
  --locale <locale>  Date/time locale formatting
  --offline          Use pre-cached pricing data
  -h, --help         Show this help

Examples:
  codecliusage.sh                              # Daily Claude Code report
  codecliusage.sh daily --breakdown            # Daily with model breakdown
  codecliusage.sh monthly --compact            # Compact monthly report
  codecliusage.sh daily --since 20250601       # Daily from June 1st
  codecliusage.sh --tool codex daily           # Daily Codex report
  codecliusage.sh daily --instances            # Group by project
EOF
    exit 0
}

# Parse --tool flag and collect remaining args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        --tool)
            if [[ -z "$2" ]]; then
                echo "Error: --tool requires a value (claude or codex)" >&2
                exit 1
            fi
            TOOL="$2"
            shift 2
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

# Verify npx is available
if ! command -v npx &>/dev/null; then
    echo "Error: npx not found. Install Node.js and npm first." >&2
    exit 1
fi

# Select the right package
case "$TOOL" in
    claude)
        PKG="ccusage@latest"
        ;;
    codex)
        PKG="@ccusage/codex@latest"
        ;;
    *)
        echo "Error: unknown tool '$TOOL'. Use 'claude' or 'codex'." >&2
        exit 1
        ;;
esac

exec npx -y "$PKG" "${ARGS[@]}"
