# Dotfiles - Agent Guidelines

## shell_setup.sh

### Node.js Configuration

- Version controlled by `NODE_VERSION` variable (currently v24.13.0)
- Supports automatic upgrade: modify version and re-run script
- Global npm packages are backed up and restored during upgrade
- Compatible with macOS and Linux

### Upgrading Node

1. Update `NODE_VERSION` in `shell_setup.sh`
2. Run `./shell_setup.sh`
3. Script handles global package migration automatically

### Cross-platform Notes

- Use `sed 's|.*/||'` instead of `xargs basename` (BSD/GNU compatible)
- Avoid platform-specific command options

## Directory Structure

```
├── bash/       # Bash config
├── zsh/        # Zsh config
├── env/        # Environment variables and aliases
├── git/        # Git config
├── tmux/       # Tmux config
├── vim/        # Vim/Neovim config
├── rime/       # Rime input method config
└── python/     # Python related config
```

## Common Commands

```bash
# Full installation
./shell_setup.sh && ./setup_all.sh

# Update symlinks only
./setup_all.sh
```
