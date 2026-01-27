# Kitty Terminal Configuration

## Files

- `kitty.conf` - Main Kitty configuration
- `solarized_light.conf` - Solarized Light theme
- `setup.sh` - Automated setup script

## Setup

```bash
cd kitty
bash setup.sh
```

The script will:

1. Symlink `kitty.conf` and `solarized_light.conf` to `~/.config/kitty/`
2. Clone [dexpota/kitty-themes](https://github.com/dexpota/kitty-themes) to `~/.config/kitty/kitty-themes/` (skipped if already exists)
3. Create a `theme.conf -> solarized_light.conf` symlink

## Switching Themes

Update the `theme.conf` symlink to switch themes:

```bash
# Use a theme from kitty-themes
cd ~/.config/kitty
ln -sf kitty-themes/themes/Solarized_Dark.conf theme.conf

# Or switch back to the custom theme
ln -sf solarized_light.conf theme.conf
```

## kitty-themes

A third-party theme collection providing various color schemes for Kitty. See https://github.com/dexpota/kitty-themes for previews and the full theme list.
