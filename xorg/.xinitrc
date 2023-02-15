#!/bin/bash

# if [ -d /etc/X11/xinit/xinitrc.d ]; then
#     for f in /etc/X11/xinit/xinitrc.d/*; do
# 	[ -x "$f" ] && . "$f"
#     done
#     unset f
# fi
#
# export XDG_SESSION_TYPE=X11
# wmname LG3D &
# xsetroot -cursor_name left_ptr &
# setxkbmap -option caps:escape &
# /usr/bin/lxpolkit &
# /usr/bin/emacs --daemon &
# xrdb -merge "$HOME"/.config/x11/xresources &
# sxhkd &
#
# while :; do 
#     ssh-agent dwm
# done

exec awesome
# exec bspwm
