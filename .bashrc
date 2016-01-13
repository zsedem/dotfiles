# If not running interactively, don't do anything!
[[ $- != *i* ]] && return
! [[ -z "$DISPLAY" ]] && [[ -z "$ATOM_HOME" ]] && [[ -z "$TMUX" ]] && exec bash -c "tmux -q has-session && exec tmux attach-session || exec tmux"


shopt -s checkwinsize
shopt -s histappend

case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
        ;;
    screen|tmux)
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
        ;;
esac

[[ "$PS1" ]] && ([ -r /usr/bin/fortune ] && /usr/bin/fortune)
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)


# we have colors :-)

# Enable colors for ls, etc. Prefer ~/.dir_colors
if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
        eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
        eval $(dircolors -b /etc/DIR_COLORS)
    fi
fi

. /usr/share/git/completion/git-prompt.sh &> /dev/null # Not always needed
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM=1
EDITOR=vim
HISTSIZE=99999999999999
HISTCONTROL=ignoredups:erasedups
PS1='$(git_status=$(__git_ps1) last_exit_code=$? zsedem-prompt)\n\[\033[31m\]> \[\033[00m\]'

alias ls="ls --color=auto"
alias tl="task list"
alias ta="task add"
alias dir="dir --color=auto"
alias grep="grep --color=auto"
alias dmesg='dmesg --color'
alias g="grep --perl-regexp"
alias c="cat"
alias e="$EDITOR"
alias f="find . "
alias fn="find . -name "
alias gti="git"  # for typos
alias inv="$(which invoke) --pty"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

alias .cathistorygrep='cat ~/.bash_history | grep'
alias SystemUpgrade='sudo pacman -Syu && sudo bootctl update && sudo pkgfile --update && sudo aura -Au'
alias PacmanClearCache='sudo pacman -Scc && sudo pacman-optimize'


PS2="> "
PS3="> "
PS4="+ "

unset safe_term match_lhs

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -r /usr/share/bash-completion/bash_completion ] || echo "Run 'pacman -S bash-completion' for bash completion"
[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash
[ -r /usr/share/doc/pkgfile/command-not-found.bash ] || echo "Run 'pacman -S pkgfile' for command not found hook"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

function .pushbranch(){
    currentbranch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$currentbranch" == "master" ]]; then
        echo "This method not for pushing master"
    else
        git push -f || git push --set-upstream origin $currentbranch
    fi
}

function .fixupfile(){
    git add $1
    git commit -s --fixup=$(git log --format="%H" -1 $1)
}


function .dockerclean(){
    docker ps -aq | xargs --no-run-if-empty docker rm
    docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
}

function .poll-command() {
    while true; do inotifywait -r -emodify,move,create . &> /dev/null; $@ ; done
}

source ~/.bashrc.local
