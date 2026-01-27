#!/usr/bin/env bash
set -e

KITTY_CONFIG_DIR="$HOME/.config/kitty"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$KITTY_CONFIG_DIR"

# Backup existing config
function backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up $1 -> $1.bak"
        mv "$1" "$1.bak"
    fi
}

backup_if_exists "$KITTY_CONFIG_DIR/kitty.conf"
backup_if_exists "$KITTY_CONFIG_DIR/solarized_light.conf"

# Symlink config files
ln -sf "$SCRIPT_DIR/kitty.conf" "$KITTY_CONFIG_DIR/kitty.conf"
ln -sf "$SCRIPT_DIR/solarized_light.conf" "$KITTY_CONFIG_DIR/solarized_light.conf"
echo "Linked kitty.conf and solarized_light.conf"

# Clone kitty-themes if not exists
if [ ! -d "$KITTY_CONFIG_DIR/kitty-themes" ]; then
    git clone https://github.com/dexpota/kitty-themes.git "$KITTY_CONFIG_DIR/kitty-themes"
    echo "Cloned kitty-themes"
else
    echo "kitty-themes already exists, skipping"
fi

# Create theme.conf symlink
ln -sf "$KITTY_CONFIG_DIR/solarized_light.conf" "$KITTY_CONFIG_DIR/theme.conf"
echo "Linked theme.conf -> solarized_light.conf"

echo "Kitty setup complete!"
