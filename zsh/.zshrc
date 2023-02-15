# Enable colors
autoload -U colors && colors

# Automatically cd into typed directory
setopt autocd

# Disable C-s to freeze terminal
stty stop undef

# History in cache directory
HISTFILE=~/.cache/zsh/history
HISTSIZE=1000
SAVEHIST=1000

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

# Vi keybindings
bindkey -v

# Aliases
alias ls='exa -l --color=always --group-directories-first' 
alias la='exa -al --color=always --group-directories-first' 
alias ytp='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'
alias yts='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s"'
alias aurupd='paru -Sua'
alias typingtest='$HOME/.cargo/bin/toipe -n 100 -w top25000'
alias weather="curl wttr.in"
alias suckless='make clean && rm -f config.h'
alias utftest='curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt'
alias mytmux='tmux new-session -A -s tempterm'
alias ssh='TERM=xterm-256color ssh'

# Archive extractor
function extract {
    if [ -z "$1" ]; then
	# display usage if no parameters given
	echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
	echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
	for n in "$@"
	do
	    if [ -f "$n" ] ; then
		case "${n%,}" in
		    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
			tar xvf "$n"       ;;
		    *.lzma)      unlzma ./"$n"      ;;
		    *.bz2)       bunzip2 ./"$n"     ;;
		    *.cbr|*.rar)       unrar x -ad ./"$n" ;;
		    *.gz)        gunzip ./"$n"      ;;
		    *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
		    *.z)         uncompress ./"$n"  ;;
		    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
			7z x ./"$n"        ;;
		    *.xz)        unxz ./"$n"        ;;
		    *.exe)       cabextract ./"$n"  ;;
		    *.cpio)      cpio -id < ./"$n"  ;;
		    *.cba|*.ace)      unace x ./"$n"      ;;
		    *)
			echo "extract: '$n' - unknown archive method"
			return 1
			;;
		esac
	    else
		echo "'$n' - file does not exist"
		return 1
	    fi
	done
    fi
}

# Starship prompt
eval "$(starship init zsh)"

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
