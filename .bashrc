# return if not interactive
[[ $- != *i* ]] && return

# export
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=
export HISTSIZE=
#export PATH=$PATH$( find ~/.local/share/nvim/lsp_servers -type d -printf ":%p")

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
    cd "$HOME" && cd "$(fd --type d --hidden | fzf)" 
}
open_with_fzf() {
    cd "$HOME" && xdg-open "$(fd --type f --hidden | fzf)"
}

lf () {
	LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
	LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
	if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
		cd "$(cat "$LF_TEMPDIR/lastdir")"
	fi
	rm -r "$LF_TEMPDIR"
	unset LF_TEMPDIR
}

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
alias config='/usr/bin/git --git-dir=/home/chris/dotfiles --work-tree=/home/chris'
alias aurupd='paru -Sua'
alias int='cd ~/doc/Uni/6.Semester/Internet/uebung/'
alias mpv='mpv --wid=$(xdotool getactivewindow)'
alias sxiv='sxiv -e $WINDOWID'
alias typingtest='$HOME/.cargo/bin/toipe -n 100 -w top25000'
alias suck='sudo make install'
alias weather="curl wttr.in"

# archive extractor
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
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
