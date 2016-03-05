xrdb ~/.Xresources
numlockx
session=${1:-xmonad}

case $session in
    xmonad            ) stack exec xmonad 2>&1 > .xmonad.log;;
    *) stack exec ~/scripts/exec_fullscreen "$@";;
esac
