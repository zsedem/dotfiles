# Path to your oh-my-zsh installation.
SHELL=`which zsh`
export ZSH=$HOME/.config/oh-my-zsh

if [ -e /home/zsedem/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zsedem/.nix-profile/etc/profile.d/nix.sh; fi

ZSH_THEME="random"
alias changetheme='ZSH_THEME=`ls ~/.config/oh-my-zsh/themes/ | cut -d"." -f1 | ~/.fzf/bin/fzf ` source ~/.config/oh-my-zsh/oh-my-zsh.sh'

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_IGNORE_ALL_DUPS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# PLUGINS
plugins=(git zsh-256-color vi-mode syntax-highlighting)

autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
source $ZSH/oh-my-zsh.sh
for i in `ls ~/.config/shrc.d/*`; do source $i; done;
setopt histignoredups

