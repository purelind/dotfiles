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

- **Primary target: macOS; also support Linux (Fedora & Ubuntu)**
- Every script change must be tested/considered for all three platforms
- Use `sed 's|.*/||'` instead of `xargs basename` (BSD/GNU compatible)
- Prefer POSIX-compatible commands; when platform-specific logic is unavoidable, use `uname` or `$OSTYPE` to branch
- On Linux, account for differences between Fedora (`dnf`) and Ubuntu (`apt`)
- Avoid platform-specific command flags without a compatibility check

### Path & Portability Rules

- **Never hardcode user home paths** (e.g., `/Users/mori/...` or `/home/mori/...`)
- Always use `$HOME`, `~`, or dynamically resolved paths (`$(whoami)`, `$(dirname "$0")`, etc.)
- The user may run these dotfiles on multiple Mac machines with different usernames — scripts must work regardless of the local username
- Use `$HOME` for config destinations; use script-relative paths (e.g., `DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"`) for source references

### Code Style

- All comments in scripts must be written in **English**

## Directory Structure

```
├── bash/       # Bash config
├── zsh/        # Zsh config
├── env/        # Environment variables and aliases
├── git/        # Git config
├── kitty/      # Kitty terminal config
├── tmux/       # Tmux config
├── vim/        # Vim/Neovim config
├── rime/       # Rime input method config
├── python/     # Python related config
└── archive/    # Deprecated configs (e.g., alacritty)
```

## Common Commands

```bash
# Full installation
./shell_setup.sh && ./setup_all.sh

# Update symlinks only
./setup_all.sh
```
