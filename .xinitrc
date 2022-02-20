#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -option caps:escape &
sxhkd &
xsetroot -cursor_name left_ptr &
feh --bg-scale ~/pic/monterey.png &
/usr/bin/emacs --daemon &
dunst &
dwmblocks &
exec dwm > /dev/null 2>&1
