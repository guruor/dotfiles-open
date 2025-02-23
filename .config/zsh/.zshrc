unsetopt PROMPT_SP

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Install antidote zsh plugin manager if not present
if [[ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -a zsh/mapfile mapfile

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Adding git status to the prompt
autoload -Uz vcs_info
# Loading async plugin
# autoload -Uz async && async
setopt prompt_subst

setopt autocd		# Automatically cd into typed directory.
stty stop undef <$TTY >$TTY     # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTDIR=~/.cache/zsh/
HISTFILE="${HISTDIR}/history"
# Creating history file if does not exist
[ ! -f "$HISTFILE" ] && mkdir -p $HISTDIR && touch $HISTFILE

# Doesn't save listed commands in history
HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..|history|code|vim|dot|pdot)"
# Ignores commands starting with space
setopt HIST_IGNORE_SPACE
# Immediately saved to history file instead of waiting for session end
setopt INC_APPEND_HISTORY
# Ignores duplicates while listing
setopt HIST_FIND_NO_DUPS
# Removes the previous copy of the command in history
setopt HIST_IGNORE_ALL_DUPS

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functions" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functions"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"


# Basic auto/tab complete:
autoload -U compinit bashcompinit
zmodload zsh/complist

# FPATH specific config, brew installed tool completion files are installed in this path
# To reset the completion cache, use: rm $ZDOTDIR/.zcompdump*
if [[ "$(command -v brew)" ]]; then
  # Add completion files to below path:
  # Ex: ente completion zsh >> "${ZSH_COMPLETIONS_PATH}/_ente"
  ZSH_COMPLETIONS_PATH="$(brew --prefix)/share/zsh/site-functions/"
  # fpath should be updated before `compinit`
  fpath=($fpath ${ZSH_COMPLETIONS_PATH})
fi

compinit
bashcompinit

# Loading bash completions for rea-as tool
source <(rea-as completion)

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use terminal file manager to switch directories and bind it to ctrl-o
tfmcd () {
    yazi
}

# Opening current directory by default
bindkey -s '^o' 'tfmcd $PWD \n'

__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

# Use to search command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    sort -k2 -k1rn | uniq -f 1 | sort -r -n |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
# Ctrl+R will trigger history search
bindkey '^R' fzf-history-widget
# Backward search in vi mode will also trigger history search
bindkey -a '?' fzf-history-widget

function fzf_alias() {
    local selection
    if selection=$(alias | fzf --query="$BUFFER" | sed -re 's/=.+$/ /'); then
        BUFFER=$selection
    fi
    zle redisplay
}

zle -N fzf_alias

bindkey -M vicmd '^a' fzf_alias
bindkey -M viins '^a' fzf_alias
# bindkey -s '^a' 'bc -lq\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

if ! typeset -f escape-clear-cmd >/dev/null; then
function escape-clear-cmd {
    echo 'clear'
}
fi

function escape-clear {
    # Only run escape-clear commands when the command line is empty and when on the first line (PS1)
if ! (( $#BUFFER )) && [[ "$CONTEXT" == start ]]; then
    BUFFER=$(escape-clear-cmd)
    zle accept-line -w
fi
}

# In normal mode hitting ESC will clear the terminal
zle -N escape-clear
bindkey -Mvicmd "\e" escape-clear

# Auto type tmux when zsh is loaded
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#     stty -echo && sleep 0.2 && xdotool type --delay 15 'tmux' && stty echo
# fi

# We are using evalcache to cache eval operations
# Make sure to trigger `_evalcache_clear` if cache needs to be cleared

# if [[ ${machine} == "Linux" ]]; then
# 	if $(pacman -Qs libxft-bgra >/dev/null 2>&1); then
# 		# Start graphical server on user's current tty if not already running.
# 		[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
# 	else
# 		echo "\033[31mIMPORTANT\033[0m: Note that \033[32m\`libxft-bgra\`\033[0m must be installed for this build of dwm.
# 	Please run:
# 		\033[32myay -S libxft-bgra-git\033[0m
# 	and replace \`libxft\`. Afterwards, you may start the graphical server by running \`startx\`."
# 	fi
#
# 	# Switch escape and caps if tty and no passwd required:
# 	sudo -n loadkeys ${XDG_DATA_HOME:-$HOME/.local/share}/larbs/ttymaps.kmap 2>/dev/null
# fi

# Brew Stuff
if [[ $MACHINE == "Linux" || $MACHINE == "WSL" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

if [[ $MACHINE == "Mac" ]]; then
    # Brew path changes for x86 and m1 users
    # For x86 Users, uncomment below and comment m1 BREW_PREFIX if not x86 installation needs to be used
    # BREW_PREFIX="/usr/local"
    # For M1 users
    BREW_PREFIX="/opt/homebrew"
fi

# Initializing brew
[ -f "${BREW_PREFIX}/bin/brew" ] && _evalcache "${BREW_PREFIX}/bin/brew" shellenv

# Homebrew or linuxbrew specific config
if [[ "$(command -v brew)" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=1
    # Adds zsh completions from brew

    # Make all GNU flavor commands available, may override same-name BSD flavor commands
    export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}"
    export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:${MANPATH}"

    # Appending brew binaries path at end to prioritize other binaries like asdf binaries
    export PATH="$PATH:$(brew --prefix)/bin"

    [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ] && source $(brew --prefix asdf)/libexec/asdf.sh

    export PATH="$(brew --prefix)/opt/openjdk@21/bin:$PATH"
fi

[ -f "${CARGO_HOME}/env" ] && source "${CARGO_HOME}/env"

[ -x "$(command -v zoxide)" ] && _evalcache zoxide init zsh
# [ -x "$(command -v starship)" ] && _evalcache starship init zsh

[ -x "$(command -v thefuck)" ] && _evalcache thefuck --alias oops
# [ -x "$(command -v ohcrab)" ] && _evalcache ohcrab --shell zsh --alias oops

# Trigger asl logs cleaning, since it slows down shell on macos
# clean-asl-logs

# export DOCKER_DEFAULT_PLATFORM=linux/arm64 # Same as linux/aarch64
# export DOCKER_DEFAULT_PLATFORM=linux/amd64 # Installing pandas with pip was taking forever with amd64

# Loads powerlevel10k installed with antidote plugin
autoload -Uz promptinit && promptinit && prompt powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
