#!/bin/bash

# return if not interactive
[[ $- != *i* ]] && return

# export TERM=xterm-256color
# export COLORTERM=xterm-256color

# export
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=
export HISTSIZE=

# vi mode
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear screen'

# keybindings
bind '"\C-l":"clear\n"'
bind '"\C-f":"cd_with_fzf\n"'
bind '"\C-o":"open_with_fzf\n"'
bind '"\C-w":"sshmenu\n"'

# functions for keybindings
cd_with_fzf() {
    cd "$HOME" && cd "$(fd --type d --hidden | fzf)" || exit
}
open_with_fzf() {
    cd "$HOME" && xdg-open "$(fd --type f --hidden | fzf)"
}

# vterm stuff
vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

find-file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

# shopt
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s histappend

# ls -> exa
alias ls='exa -l --color=always --group-directories-first' 
alias la='exa -al --color=always --group-directories-first' 

# aliases
alias ytp='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'
alias yts='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s"'
alias aurupd='paru -Sua'
alias typingtest='$HOME/.cargo/bin/toipe -n 100 -w top25000'
alias suck='sudo make install'
alias weather="curl wttr.in"
alias suckless='make clean && rm -f config.h'
alias utftest='curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt'
alias mytmux='tmux new-session -A -s tempterm'
alias ssh='TERM=xterm-256color ssh'

# archive extractor
export ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.tar.xz)    tar xJf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

eval "$(starship init bash)"
