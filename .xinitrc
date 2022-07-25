#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# xsetroot -cursor_name left_ptr &
# setxkbmap -option caps:escape &
# sxhkd &
# unclutter &
# lxsession &
# lxpolkit &
# dunst &
# udiskie &
# picom --config ~/.config/picom/picom.conf --experimental-backends &
# slstatus &
exec awesome
