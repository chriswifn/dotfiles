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
# hsetroot -fill ~/pic/dark-minimal.jpg &
lxsession &
/usr/bin/emacs --daemon &
dunst &
slstatus &

while :; do 
  ssh-agent dwm
done
