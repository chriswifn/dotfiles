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

# archive extractor
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

eval "$(starship init bash)"
