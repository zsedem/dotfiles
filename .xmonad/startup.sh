export _JAVA_AWT_WM_NONREPARENTING=1
feh  --image-bg black --bg-center "$HOME/.xmonad/xmonad.jpg" &
xrdb  ~/.Xresources &
xsetroot -cursor_name left_ptr &
xset b off &
dunst -conf ~/.dunstrc &
xscreensaver &
gnome-terminal --hide-menubar &