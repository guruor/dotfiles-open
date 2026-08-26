export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Keep completion paths unique even if an installer adds one again.
typeset -gU fpath
