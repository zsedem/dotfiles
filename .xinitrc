xrdb ~/.Xresources
numlockx
stack exec taffybar 2>&1 > .taffybar.log &
stack exec xmonad 2>&1 > .xmonad.log
