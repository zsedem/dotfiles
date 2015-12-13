#!/bin/sh
xmonad --restart;
xrdb ~/.Xresources &
xsetroot -cursor_name left_ptr &
nitrogen --restore
nm-applet &
#volumeicon &
compton --config ~/.config/compton.conf -b &
urxvt &
