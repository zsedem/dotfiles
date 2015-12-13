#!/bin/sh

rm -rf ~/.xmonad/xmonad.{errors,hi,o}
rm -rf ~/.xmonad/xmonad-i386-linux;
xmonad --recompile
killall conky
killall dzen2
xmonad --restart
