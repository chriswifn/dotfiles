# export
# export TERM="xterm-256color"
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=
export HISTSIZE=

# vi mode
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear screen'

# return if not interactive
[[ $- != *i* ]] && return

# title of terminals
case ${TERM} in
  xterm*|alacritty|st-256color)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

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
alias n='nvim'
alias config='/usr/bin/git --git-dir=/home/chri/dotfiles --work-tree=/home/chri'
alias aurupd='yay -Sua'

eval "$(starship init bash)"
