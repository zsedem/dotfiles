#!/bin/sh
xmonad --restart
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr &
nitrogen --restore &
nm-applet &
xscreensaver -no-splash &
compton --config ~/.config/compton.conf -b &
urxvt &
