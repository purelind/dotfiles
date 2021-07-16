#!/usr/bin/env bash

# set -e          # Exit on error
# set -o pipefail # Exit on pipe error
# set -x          # Enable verbosity

# Dont link DS_Store files
find . -name ".DS_Store" -exec rm {} \;

PROGRAMS=(bash env git python tmux vim zsh)
# PROGRAMS=(alias aspell bash env git latex python scripts stow tmux vim zsh mac terminal)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

function backup_if_exists() {
    if [ -f $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
    if [ -d $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
}

# Clean common conflicts
backup_if_exists ~/.bash_login
backup_if_exists ~/.bash_logout
backup_if_exists ~/.bash_profile
backup_if_exists ~/.bashrc
backup_if_exists ~/.inputrc

backup_if_exists ~/.alias
backup_if_exists ~/.env
backup_if_exists ~/.profile

backup_if_exists ~/.gitconfig
backup_if_exists ~/.gitignore_global

backup_if_exists ~/.screenrc
backup_if_exists ~/.tmux.conf
backup_if_exists ~/.tmux-remote.conf

backup_if_exists ~/.vimrc

backup_if_exists ~/.p10k.zsh
backup_if_exists ~/.zlogin
backup_if_exists ~/.zlogout
backup_if_exists ~/.zpreztorc
backup_if_exists ~/.zprofile
backup_if_exists ~/.zshenv
backup_if_exists ~/.zshrc

mkdir -p ~/.vim/undodir


for program in ${PROGRAMS[@]}; do
  echo ">>> Configuring $program"
  stow -v --target=$HOME $program
  echo "Configuring $program finised"
done
