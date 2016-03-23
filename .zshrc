# Path to your oh-my-zsh installation.
SHELL=`which zsh`

export ZSH=/home/zsedem/.oh-my-zsh

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
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
try_source /usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
_my_above_line_promptcmd (){
  "$POWERLINE_COMMAND" $=POWERLINE_COMMAND_ARGS shell above --last-exit-code=$? --last-pipe-status="$pipestatus" --renderer-arg="client_id=$$" --renderer-arg="shortened_path=${(%):-%~}" --jobnum=$_POWERLINE_JOBNUM --renderer-arg="mode=$_POWERLINE_MODE" --renderer-arg="default_mode=$_POWERLINE_DEFAULT_MODE" --width=$(( ${COLUMNS:-$(_powerline_columns_fallback)} - ${ZLE_RPROMPT_INDENT:-1} ))
}
precmd_functions+=_my_above_line_promptcmd

PROMPT='$("$POWERLINE_COMMAND" $=POWERLINE_COMMAND_ARGS shell left -r .zsh --last-exit-code=$? --last-pipe-status="$pipestatus" --renderer-arg="client_id=$$" --renderer-arg="shortened_path=${(%):-%~}" --jobnum=$_POWERLINE_JOBNUM --renderer-arg="mode=$_POWERLINE_MODE" --renderer-arg="default_mode=$_POWERLINE_DEFAULT_MODE" --width=$(( ${COLUMNS:-$(_powerline_columns_fallback)} - ${ZLE_RPROMPT_INDENT:-1} )))'

try_source ~/.fzf.zsh
