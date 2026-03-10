#!/usr/bin/env bash
# Sync shared skills and commands from dotfiles to ~/.claude/ via symlinks.
# Local-only skills/commands (regular directories/files) are preserved.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Sync skills ---
SKILLS_SRC="$SCRIPT_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$SKILLS_DST"

echo "Syncing skills..."
for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$SKILLS_DST/$skill_name"

    # Already a correct symlink — skip
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$skill_dir" ]; then
        echo "  skip: $skill_name (already linked)"
        continue
    fi

    # Exists as a regular directory — don't overwrite local skill
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        echo "  skip: $skill_name (local directory exists, not overwriting)"
        continue
    fi

    # Stale symlink or doesn't exist — create/replace
    rm -f "$target"
    ln -s "$skill_dir" "$target"
    echo "  link: $skill_name -> $skill_dir"
done

# --- Sync commands ---
COMMANDS_SRC="$SCRIPT_DIR/commands"
COMMANDS_DST="$HOME/.claude/commands"

if [ -d "$COMMANDS_SRC" ]; then
    mkdir -p "$COMMANDS_DST"

    echo "Syncing commands..."
    for cmd_file in "$COMMANDS_SRC"/*.md; do
        [ -f "$cmd_file" ] || continue
        cmd_name="$(basename "$cmd_file")"
        target="$COMMANDS_DST/$cmd_name"

        # Already a correct symlink — skip
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$cmd_file" ]; then
            echo "  skip: $cmd_name (already linked)"
            continue
        fi

        # Exists as a regular file (not symlink) — don't overwrite local command
        if [ -f "$target" ] && [ ! -L "$target" ]; then
            echo "  skip: $cmd_name (local file exists, not overwriting)"
            continue
        fi

        # Stale symlink or doesn't exist — create/replace
        rm -f "$target"
        ln -s "$cmd_file" "$target"
        echo "  link: $cmd_name -> $cmd_file"
    done
fi

echo "done."
