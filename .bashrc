# If not running interactively, don't do anything!
[[ $- != *i* ]] && return
alias rehash='echo' # for compatibility with zsh
function try_source(){
    [ -r $1 ] && source $1
    return 0
}
SHELL=`which bash`

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

try_source `which git | sed 's|\(.*\)/.*|\1|'`/../share/git/contrib/completion/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM=1
EDITOR=vim
HISTSIZE=99999
HISTCONTROL=ignoredups:erasedups

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
hostnamesalt=thisisforhavinggreenforzsedem-lt21
hostnamecolor="\e[38;5;$((0x$( (echo "$hostnamesalt"; hostname) | sha256sum | cut -f1 -d' ' | tr -d '\n' | tail -c2)))m"

PS1="$hostnamecolor\u@\h\[\033[01;34m\] \w\$(last_exit_status=\$?; [[ \$last_exit_status != 0 ]] && echo \"\[\033[01;31m\] (\$last_exit_status)\" || echo \"\[\033[01;32m\] :)\")\[\033[00m\]\[\033[1;33m\]\$(__git_ps1)\[\033[01;31m\] \t\n> $\[\033[00m\] "
try_source ~/.bashrc.local

