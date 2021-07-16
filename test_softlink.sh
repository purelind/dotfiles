#!/usr/bin/env zsh
set -x
set -e


setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    echo "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    # -L returns true if the "file" exists and is a symbolic link (the linked file may or may not exist). 
    if [ -L "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
    echo "${ZDOTDIR:-$HOME}/.${rcfile:t}: is softlink"
    else
    echo "${ZDOTDIR:-$HOME}/.${rcfile:t}: not softlink"
    fi
    # back if it is file
    # backup_if_exists $rcfile
    # ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done