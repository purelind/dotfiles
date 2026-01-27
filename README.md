# Purelind Dotfiles (macOS & Linux)

## Supported Configurations

* Bash / Zsh
* Git
* Tmux
* Vim / Neovim
* Rime input method
* Iterm2 / Alacritty

Inspired by [Jose Javier Gonzalez dotfiles](https://github.com/jjgo/dotfiles)

## Dependencies

```bash
# macOS
brew install stow readline xz

# Fedora
dnf install stow

# Ubuntu/Debian
apt install stow
```

## Installation

```bash
# 1. Install zsh and set as default shell
# 2. Run setup scripts
./install_dev_tools.sh
./stow_dotfiles.sh
```

## Files

- `install_dev_tools.sh`: Install dev tools (Node, Rust, Neovim, etc.)
- `stow_dotfiles.sh`: Create config symlinks
- `AGENTS.md`: AI assistant guidelines

## Tips

Increase terminal cursor speed: System Preferences → Keyboard → Key Repeat Rate
