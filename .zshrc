# Path to your oh-my-zsh installation.
SHELL=`which zsh`
export ZSH=$HOME/.config/oh-my-zsh

if [ -e /home/zsedem/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zsedem/.nix-profile/etc/profile.d/nix.sh; fi

ZSH_THEME="jonathan"
alias changetheme='ZSH_THEME=`ls ~/.config/oh-my-zsh/themes/ | cut -d"." -f1 | fzf ` source ~/.config/oh-my-zsh/oh-my-zsh.sh'

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
HIST_IGNORE_ALL_DUPS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# PLUGINS
plugins=(git zsh-256-color vi-mode syntax-highlighting)
source $ZSH/oh-my-zsh.sh

autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
for i in `ls ~/.config/shrc.d/*`; do source $i; done;
setopt histignoredups

command_not_found_handler() {
    local p=/run/current-system/sw/bin/command-not-found
    if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
      # Run the helper program.
      $p "$@"
      # Retry the command if we just installed it.
      if [ $? = 126 ]; then
        "$@"
      fi
    else
      # Indicate than there was an error so ZSH falls back to its default handler
      return 127
    fi
}

# key bindings
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[P" delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey ' ' magic-space
source /run/current-system/sw/share/fzf/key-bindings.zsh
