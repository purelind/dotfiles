---
name: codecliusage
description: "Query local Claude Code and Codex token usage, costs, and session stats via ccusage CLI."
---

# Code CLI Usage Skill

Query and analyze token consumption and costs from local Claude Code and Codex interactions. Uses the [ccusage](https://github.com/ryoppippi/ccusage) CLI tool to parse local JSONL session files.

## Quick Reference

| Task | Command |
|------|---------|
| Daily usage report (default) | `./scripts/codecliusage.sh` |
| Monthly aggregated report | `./scripts/codecliusage.sh monthly` |
| Session-level breakdown | `./scripts/codecliusage.sh session` |
| 5-hour billing windows | `./scripts/codecliusage.sh blocks` |
| Daily with date range | `./scripts/codecliusage.sh daily --since 20250525 --until 20250530` |
| Per-model cost breakdown | `./scripts/codecliusage.sh daily --breakdown` |
| Group by project | `./scripts/codecliusage.sh daily --instances` |
| Filter by project name | `./scripts/codecliusage.sh daily --project myproject` |
| JSON output | `./scripts/codecliusage.sh daily --json` |
| Compact table | `./scripts/codecliusage.sh daily --compact` |
| Codex usage | `./scripts/codecliusage.sh --tool codex daily` |

## Prerequisites

- **Node.js** (v18+) must be installed
- **npx** must be available (comes with npm)
- No additional installation needed; the script runs `npx ccusage@latest` directly

---

## Main Wrapper Script

```bash
./scripts/codecliusage.sh [--tool claude|codex] [command] [options]
```

Wrapper around `ccusage` / `@ccusage/codex` that provides a unified interface for querying Claude Code and Codex token usage.

**Tool Selection:**
- `--tool claude` - Query Claude Code usage (default)
- `--tool codex` - Query OpenAI Codex usage

**Commands:**
- `daily` - Daily token usage and costs (default if omitted)
- `monthly` - Monthly aggregated report
- `session` - Usage grouped by conversation session
- `blocks` - 5-hour billing window tracking
- `statusline` - Compact status line for hooks (Beta)

**Common Options:**
- `--since YYYYMMDD` - Start date filter
- `--until YYYYMMDD` - End date filter
- `--json` - JSON output format
- `--breakdown` - Per-model cost breakdown
- `--compact` - Force compact table layout
- `--instances` - Group by project/instance
- `--project <name>` - Filter to specific project
- `--timezone <tz>` - Timezone for date grouping (e.g., UTC)
- `--locale <locale>` - Date/time formatting locale (e.g., ja-JP)
- `--offline` - Use pre-cached pricing data (no network)

---

## Common Workflows

### Check Today's Usage

```bash
# Quick daily overview
./scripts/codecliusage.sh

# With per-model cost breakdown
./scripts/codecliusage.sh daily --breakdown
```

### Review a Specific Date Range

```bash
./scripts/codecliusage.sh daily --since 20250601 --until 20250630
```

### Monthly Cost Summary

```bash
./scripts/codecliusage.sh monthly

# With compact table for sharing
./scripts/codecliusage.sh monthly --compact
```

### Per-Project Analysis

```bash
# See all projects
./scripts/codecliusage.sh daily --instances

# Focus on a specific project
./scripts/codecliusage.sh daily --instances --project myproject
```

### Export Data as JSON

```bash
# Pipe to jq for further processing
./scripts/codecliusage.sh daily --json | jq '.[] | {date, totalCost}'
```

### Check Codex Usage

```bash
./scripts/codecliusage.sh --tool codex daily
./scripts/codecliusage.sh --tool codex monthly --breakdown
```

---

## Troubleshooting

### npx Not Found

Ensure Node.js and npm are installed:
```bash
node --version
npm --version
```

### No Data Returned

- Claude Code session logs are stored in `~/.claude/projects/`. Ensure this directory exists and contains `.jsonl` files.
- Check that the date range (`--since`, `--until`) covers periods with actual usage.

### Slow Startup

The first run may be slow as npx downloads `ccusage@latest`. Subsequent runs use the cached version. Use `--offline` to skip pricing data fetch if you only need Claude model costs.

---

## Tips

1. **Start with `daily`** - It's the default and gives you a quick overview of recent usage
2. **Use `--breakdown`** - See exactly which models are consuming tokens
3. **Use `--instances`** - Identify which projects are the most expensive
4. **Use `--json` + jq** - For scripting and custom analysis
5. **Use `--compact`** - Better for narrow terminals or screenshots
