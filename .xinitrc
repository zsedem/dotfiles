xrdb ~/.Xresources
numlockx
session=${1:-xmonad}

case $session in
    xmonad            ) stack exec taffybar 2>&1 > .taffybar.log &
                        stack exec xmonad 2>&1 > .xmonad.log;;
    *) exec $1;;
esac
