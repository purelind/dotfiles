Purelind dotfile (MacOS & Linux)

目前支持以下常用配置：

* Bash

* Zsh

* Git

* Tumux

* Vim

* Custom scripts

* Rime

* Vscode
* Iterm2

  



其中大部分配置来源于 [Jose Javier Gonzalez dotfiles](https://github.com/jjgo/dotfiles)


Some base tools
* brew
* stow
* pyenv
* others lib
  ```shell
  brew install readline xz
  ```
* iterm2
  1. increase the cursor speed in terminal  https://stackoverflow.com/questions/4489885/how-can-i-increase-the-cursor-speed-in-terminal
     System Preferences => Keyboard => increase Key Repeat Rate
  



Usage
1. install `zsh`, set zsh as your default shell
2. install 'stow'
fedora
```shell
# dnf install stow
```
ubuntu/debian
```shell
# apt install stow
```
mac
```shell
#  brew install stow
```
3. go
```shell

./shell_setup.sh
./setup_all.sh
```


### new
install gpg2
install rvm
install new ruby version
install cocoapods
* 使用 asdf 管理部分环境

