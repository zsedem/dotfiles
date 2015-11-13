#
# ~/.bash_profile
#

export PATH=$HOME/.local/bin:$PATH
[[ -f ~/.bashrc ]] && . ~/.bashrc
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
source $HOME/.bash_profile.local
