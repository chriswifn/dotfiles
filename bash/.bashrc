#
# ~/.bashrc
#

case $- in
*i*) ;; # interactive
*) return ;;
esac

#-------------------------------------------------------------------------------
# local utility functions
#-------------------------------------------------------------------------------
_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

#-------------------------------------------------------------------------------
# environment variables
#-------------------------------------------------------------------------------
# export TERM=xterm-256color
export EDITOR=vim
export VISUAL=vim
export GOPATH="$HOME/.local/share/go"
export GOBIN="$HOME/.local/bin"
export LESS="-FXR"
export LESS_TERMCAP_mb=$'\E[6m'          # begin blinking
export LESS_TERMCAP_md=$'\E[34m'         # begin bold
export LESS_TERMCAP_us=$'\E[4;32m'       # begin underline
export LESS_TERMCAP_so=$'\E[1;33;41m'    # begin standout-mode - info box
export LESS_TERMCAP_me=$'\E[0m'          # end mode
export LESS_TERMCAP_ue=$'\E[0m'          # end underline
export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
export MOZ_ENABLE_WAYLAND=1
export GITUSER="chriswifn"
export REPOS="$HOME/repos"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"
export SNIPPETS="$DOTFILES/snippets"

#-------------------------------------------------------------------------------
# pager
#-------------------------------------------------------------------------------
if [[ -x /usr/bin/lesspipe ]]; then
  export LESSOPEN="| /usr/bin/lesspipe %s";
  export LESSCLOSE="/usr/bin/lesspipe %s %s";
fi

#-------------------------------------------------------------------------------
# dircolors
#-------------------------------------------------------------------------------
if _have dircolors; then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

#-------------------------------------------------------------------------------
# path
#-------------------------------------------------------------------------------
pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//":$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="${PATH:+"$PATH:"}$arg"
  done
} && export -f pathappend

pathprepend() {
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//:"$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="$arg${PATH:+":${PATH}"}"
  done
} && export -f pathprepend

pathprepend \
    "$HOME/.local/bin" \
    "$HOME/repos/github.com/chriswifn/cmd-zet" \
    "$HOME/bin"

#-------------------------------------------------------------------------------
# cdpath
#-------------------------------------------------------------------------------
export CDPATH=".:$GHREPOS:$HOME/media/uni/01:$HOME/media/uni/02/:$HOME"

#-------------------------------------------------------------------------------
# bash shell options
#-------------------------------------------------------------------------------
shopt -s checkwinsize  # enables $COLUMNS and $ROWS
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob

#-------------------------------------------------------------------------------
# stty annoyances
#-------------------------------------------------------------------------------
stty stop undef # disable control-s accidental terminal stops

#-------------------------------------------------------------------------------
# bash shell options 
#-------------------------------------------------------------------------------
shopt -s checkwinsize  # enables $COLUMNS and $ROWS
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob

#-------------------------------------------------------------------------------
# history
#-------------------------------------------------------------------------------

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000
set -o vi
shopt -s histappend

#-------------------------------------------------------------------------------
# prompt
#-------------------------------------------------------------------------------
PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@

__ps1() {
    local P='$' dir="${PWD##*/}" B countme short long double\
        r='\[\e[31m\]' g='\[\e[37m\]' h='\[\e[34m\]' \
        u='\[\e[33m\]' p='\[\e[34m\]' w='\[\e[35m\]' \
        b='\[\e[36m\]' x='\[\e[0m\]'

    [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
    [[ $PWD = / ]] && dir=/
    [[ $PWD = "$HOME" ]] && dir='~'

    B=$(git branch --show-current 2>/dev/null)
    [[ $dir = "$B" ]] && B=.
    countme="$USER$PROMPT_AT$(hostname):$dir($B)\$ "

    [[ $B == master || $B == main ]] && b="$r"
    [[ -n "$B" ]] && B="$g($b$B$g)"

    if [[ $SHLVL == "1" ]]; then
      N=""
    else
      N="[nix-shell]"
    fi

    short="$u\u$g$PROMPT_AT$h\h$g:$w$dir$B$N$p$P$x "
    long="$u\u$g$PROMPT_AT$h\h$g:$w$dir$B$N\n$p$P$x "
    double="$u\u$g$PROMPT_AT$h\h$g:$w$dir\n$B$N\n$p$P$x "

    if (( ${#countme} > PROMPT_MAX )); then
        PS1="$double"
    elif (( ${#countme} > PROMPT_LONG )); then
        PS1="$long"
    else
        PS1="$short"
    fi
}

PROMPT_COMMAND="__ps1"

#-------------------------------------------------------------------------------
# aliases
#-------------------------------------------------------------------------------
unalias -a
alias ls='ls -h --color=auto'
alias diff='diff --color'
alias grep='grep --color=auto'
alias '?'=duck
alias temp='cd $(mktemp -d)'
alias ytp='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'
alias yts='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s"'
alias battery='cat /sys/class/power_supply/BAT0/capacity'

#-------------------------------------------------------------------------------
# functions
#-------------------------------------------------------------------------------
ex() {

    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *.deb)       ar x "$1"      ;;
            *.tar.xz)    tar xf "$1"    ;;
            *.tar.zst)   unzstd "$1"    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#-------------------------------------------------------------------------------
# completion
#-------------------------------------------------------------------------------
bind 'set completion-ignore-case on'
complete -c man which
complete -cf sudo
complete -C screenshot screenshot
complete -C theme theme
complete -C z z
