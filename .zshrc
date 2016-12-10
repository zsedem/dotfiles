# Path to your oh-my-zsh installation.
SHELL=`which zsh`

export ZSH=/home/zsedem/.oh-my-zsh


ZSH_THEME="amuse"

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
source ~/.shrc
try_source ~/.zsh/completion/_docker-compose
try_source ~/.fzf.zsh
setopt histignoredups
