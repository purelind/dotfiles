#!/usr/bin/env zsh
set -x
set -e

OLD_DOTFILES="dotfile_bk_shell_setup_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

function backup_if_exists() {
    if [ -f $1 ];
    then
      cp -rp $1 $OLD_DOTFILES
    fi
}

# Clean common conflicts
backup_if_exists ~/.bash_profile
backup_if_exists ~/.bashrc
backup_if_exists ~/.zshrc
backup_if_exists ~/.gitconfig
backup_if_exists ~/.tmux.conf
backup_if_exists ~/.profile

#######################
# BIN
#######################

function pull_repo() {
    cd $1
    git pull
    cd -
}

mkdir -p $HOME/bin

# FASD
if [[ ! -f $HOME/bin/fasd ]]; then
    git clone https://github.com/clvv/fasd.git /tmp/fasd
    cd /tmp/fasd
    PREFIX=$HOME make install
    cd -
fi

# FZF
if [[ ! -f $HOME/.fzf/bin/fzf ]]; then
    git clone https://github.com/junegunn/fzf.git $HOME/.fzf
    yes | $HOME/.fzf/install
fi


#######################
# TMUX
#######################

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    mkdir -p $HOME/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
pull_repo $HOME/.tmux/plugins/tpm


#######################
# ZSH
#######################
if [[ ! -d $HOME/.zprezto ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/'^README.md(.N)'; do
    # -L returns true if the "file" exists and is a symbolic link (the linked file may or may not exist).
      if [ -L "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
        echo "remove softlink ${ZDOTDIR:-$HOME}/.${rcfile:t}"
        rm -f "${ZDOTDIR:-$HOME}/.${rcfile:t}"
      else
        echo "backup file: ${ZDOTDIR:-$HOME}/.${rcfile:t}"
        backup_if_exists "${ZDOTDIR:-$HOME}/.${rcfile:t}"
      fi
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
fi
cd $HOME/.zprezto
git pull
git submodule update --init --recursive
cd -

mkdir -p $HOME/.zsh

# Fast syntax highlighting
if [[ ! -d $HOME/.zsh/fast-syntax-highlighting ]]; then
    # git clone https://github.com/zdharma/fast-syntax-highlighting.git $HOME/.zsh/fast-syntax-highlighting
    git clone git@github.com:purelind/fast-syntax-highlighting.git $HOME/.zsh/fast-syntax-highlighting
fi
pull_repo $HOME/.zsh/fast-syntax-highlighting

#######################
# NEOVIM
#######################

NVIM=$HOME/.neovim
mkdir -p $NVIM


unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}
# AppImage in case the computer does not have a fallback nvim (appimage does not self update)
if command -v nvim > /dev/null; then
    echo "NVIM appears to be installed"
else
    mkdir -p $NVIM/bin
    cd $NVIM/bin

    if [[ $machine == "Mac" ]]; then
        brew install nvim
    else
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        mv nvim.appimage nvim
    fi
    cd -
fi


# Create Python3 environment
if [[ ! -d $NVIM/py3 ]]; then
    python3 -m venv $NVIM/py3
    PIP=$NVIM/py3/bin/pip
    $PIP install --upgrade pip
    $PIP install neovim
    $PIP install 'python-language-server[all]'
    $PIP install pylint isort jedi flake8
    $PIP install black yapf
fi

# Create node env
if [[ ! -d $NVIM/node ]]; then
    mkdir -p $NVIM/node
    NODE_SCRIPT=/tmp/install-node.sh
    curl -sL install-node.now.sh/v16.2.0 -o $NODE_SCRIPT
    chmod +x $NODE_SCRIPT
    PREFIX=$NVIM/node $NODE_SCRIPT -y
    PATH="$NVIM/node/bin:$PATH"
    npm install -g neovim
fi


# DIFF-SO-FANCY
if [[ ! -f $NVIM/node/bin/diff-so-fancy ]]; then
    npm install -g  diff-so-fancy
fi


#######################
# RUST
#######################

if [[ ! -d $HOME/.rustup ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

for crate in bat fd-find ripgrep tealdeer procs ytop hyperfine bandwhich
do
    $HOME/.cargo/bin/cargo install $crate
done

# workaroud for exa
# cargo install exa failed in debian-11  (20220522)
# issue : https://github.com/ogham/exa/issues/1068
for crate in exa
do
    $HOME/.cargo/bin/rustup override set 1.66.1
    $HOME/.cargo/bin/cargo install $crate
    $HOME/.cargo/bin/rustup override unset
done


#######################
# GO
#######################
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}
if [[ $machine == "Linux" ]]; then
    if [[ ! -d $HOME/.go ]]; then
    mkdir -p $HOME/.go
    curl -LO https://go.dev/dl/go1.17.10.linux-amd64.tar.gz
    tar -C $HOME/.go -xzf go1.17.10.linux-amd64.tar.gz --strip-components=1
    rm -f go1.17.10.linux-amd64.tar.gz
    fi
    if [[ ! -d $HOME/sdk/go1.18.2 ]]; then
        mkdir -p $HOME/sdk/go1.18.2
        curl -LO https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
        tar -C $HOME/sdk/go1.18.2 -xzf go1.18.2.linux-amd64.tar.gz --strip-components=1
        rm -f go1.18.2.linux-amd64.tar.gz
    fi
    if [[ ! -d $HOME/sdk/go1.16.15 ]]; then
        mkdir -p $HOME/sdk/go1.16.15
        curl -LO https://go.dev/dl/go1.16.15.linux-amd64.tar.gz
        tar -C $HOME/sdk/go1.18.2 -xzf go1.16.15.linux-amd64.tar.gz --strip-components=1
        rm -f go1.16.15.linux-amd64.tar.gz
    fi
fi
