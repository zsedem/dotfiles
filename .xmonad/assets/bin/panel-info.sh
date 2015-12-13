#!/bin/sh

ScreenWidth=1600
fg="#efefef"
bg="#2d2d2d"
bg_volume="#4D2BC1"
font='Droid Sans Fallback-8:bold'
WidthPanelInfo=`expr $ScreenWidth / 2`
WidthPanelClock=400
WidthPanelVolume=100
PosX_info=`expr $ScreenWidth - $WidthPanelInfo`
PosX_clock=32
PosX_volume=`expr $ScreenWidth - $WidthPanelVolume`

conky -c ~/.xmonad/assets/conky/info.conkyrc | dzen2 -p -ta r -e 'button3=' -fn 'Droid Sans Fallback-8:bold' -fg $fg -bg $bg -h 25 -w $WidthPanelInfo -x $PosX_info -y 5 & disown
