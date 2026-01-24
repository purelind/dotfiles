# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#


# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi



# Tmuxinator completions
if [ -f ~/.bin/tmuxinator.zsh ]; then
    source ~/.bin/tmuxinator.zsh
fi

fpath=(/usr/local/share/zsh-completions $fpath)

export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""



# bindkey -v
# bindkey -M viins '\e.' insert-last-word
# bindkey "^R" history-incremental-search-backward
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

export EDITOR='vim'
export VISUAL='vim'

# Remap clear-screen since ^L is taken by tmux-vim
bindkey "^O" clear-screen
bindkey "^L" end-of-line

# Disable right prompt for lecture recording
# RPROMPT=

# Alt left/right moves words
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Alt up/down goes to beggining/end of line
bindkey "^[[1;3A" beginning-of-line
bindkey "^[[1;3B" end-of-line

if [ -f $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
  source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

if [ -f ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# https://github.com/marlonrichert/zsh-autocomplete
# if [ -f $HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
#   source $HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Environment setup
if [ -f ~/.env ]; then
    source ~/.env
fi

# ALIASES
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

export PATH=/Users/mori/.tiup/bin:$PATH

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
eval "$(rbenv init -)"

# [[ -s "/Users/purelind/.gvm/scripts/gvm" ]] && source "/Users/purelind/.gvm/scripts/gvm"

# bun completions
[ -s "/Users/purelind/.bun/_bun" ] && source "/Users/purelind/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"

alias claude="/Users/purelind/.claude/local/claude"
