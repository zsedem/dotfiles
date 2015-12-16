#!/bin/sh

widthscreen=$1
heightscreen=$2
col1=$3
col2=$4
dmenu_run -b -h 24 -l 9 -x `expr $widthscreen / 2 - 225` -y `expr $heightscreen / 2 - $(expr 24 \* 9 / 2)` -w 450 -nb $col1 -sb $col2 -dim 0.65