#!/bin/bash
#export PATH=$PATH:$HOME/.local/bin/
export PATH=$PATH$( find ~/.local/bin -type d -printf ":%p")
export TERMINAL="st"
export EDITOR="nvim"
export BROWSER="brave"
export READER="zathura"
export XDG_CONFIG_HOME="$HOME/.config"

[ -f ~/.bashrc ] && . ~/.bashrc


