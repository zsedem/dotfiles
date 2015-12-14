#!/bin/sh

wscreen=$1
hscreen=$2
col1=$3
col2=$4

dmenu="dmenu -i -b -h 24 -l 4 -w 300 -dim 0.7 -x `expr $wscreen / 2 - 150` -y `expr $hscreen / 2 - $(expr 24 \* 2 / 2)` -nb $col1 -sb $col2 -class URxvt"
choice=$(echo -e "LOGOUT\nSHUTDOWN\nREBOOT" | $dmenu)

case "$choice" in
  LOGOUT) pkill xmonad & ;;
  SHUTDOWN) systemctl poweroff & ;;
  REBOOT) systemctl reboot & ;;
esac

