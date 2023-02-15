# Path
typeset -U path PATH
path=(~/.local/bin $path)
path=(~/bin $path)
export PATH

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

# Default programs
export EDITOR="nvim"
export TERMINAL="st"
export READER="zathura"
export BROWSER="firefox"
