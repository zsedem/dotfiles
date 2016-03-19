# If not running interactively, don't do anything!
[[ $- != *i* ]] && return
SHELL=`which bash`
source ~/.shrc

shopt -s checkwinsize
shopt -s histappend

# Enable colors for ls, etc. Prefer ~/.dir_colors
if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
        eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
        eval $(dircolors -b /etc/DIR_COLORS)
    fi
fi

try_source /usr/share/git/completion/git-prompt.sh
try_source /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM=1
EDITOR=vim
HISTSIZE=99999999999999
HISTCONTROL=ignoredups:erasedups

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

try_source /usr/share/bash-completion/bash_completion
try_source /usr/share/doc/pkgfile/command-not-found.bash

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
try_source ~/.bashrc.local
