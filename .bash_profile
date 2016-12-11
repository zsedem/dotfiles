#
# ~/.bash_profile
#

export PATH=$HOME/.local/bin:$PATH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
[[ -f ~/.bashrc ]] && . ~/.bashrc
_JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
[[ -f ~/.bash_profile.local ]] && . $HOME/.bash_profile.local
if [ -e /home/zsedem/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zsedem/.nix-profile/etc/profile.d/nix.sh; fi
