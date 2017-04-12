#
# ~/.bash_profile
#

export PATH=$HOME/.local/bin:$PATH
[[ -f ~/.bashrc ]] && . ~/.bashrc
_JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
[[ -f ~/.bash_profile.local ]] && . $HOME/.bash_profile.local
