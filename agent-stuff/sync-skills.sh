#!/usr/bin/env bash
# Sync shared skills from dotfiles to ~/.claude/skills/ via symlinks.
# Local-only skills (regular directories) are preserved.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$SKILLS_DST"

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

echo "done. synced skills from $SKILLS_SRC"
