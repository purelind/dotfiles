# CLAUDE.md

This file provides guidance to Claude Code for user-level capabilities.

## Available Skills

The following skills are available at `~/.claude/skills/`. When a task matches these capabilities, read the corresponding `SKILL.md` for detailed usage instructions.

| Skill | When to Use | Path |
|-------|-------------|------|
| **ghidra** | Reverse engineering, binary analysis, decompilation, malware analysis | `~/.claude/skills/ghidra/SKILL.md` |
| **web-browser** | Web scraping, browser automation, interacting with web pages | `~/.claude/skills/web-browser/SKILL.md` |
| **tmux** | Interactive CLI sessions (Python REPL, gdb/lldb debugging, etc.) | `~/.claude/skills/tmux/SKILL.md` |
| **improve-skill** | Analyzing sessions to create or improve skills | `~/.claude/skills/improve-skill/SKILL.md` |

### Usage Pattern

1. When user requests a task matching these capabilities, first read the skill file:
   ```
   ~/.claude/skills/<skill-name>/SKILL.md
   ```

2. Follow the instructions in the skill file to complete the task.

3. Scripts are located in each skill's `scripts/` subdirectory.

### Prerequisites

- **ghidra**: Requires Ghidra installed (`brew install --cask ghidra`)
- **web-browser**: Dependencies already installed in `~/.claude/skills/web-browser/scripts/`

### Security Notes

Skills have been reviewed for security. The web-browser skill has been modified:
- Removed dangerous `killall Chrome` behavior
- Now runs alongside your normal Chrome safely
- See `~/.claude/skills/web-browser/SKILL.md` for details

### Acknowledgments

Some skills and commands are adapted from [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff).
