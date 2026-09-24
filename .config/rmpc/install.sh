#!/usr/bin/env bash
#
# rmpc + mpd setup for macOS. Idempotent: re-run it any time, including after
# `brew upgrade rmpc` or a change to the config in this directory.
#
# Run it AFTER the dotfiles themselves are linked (`./install.sh -i` at the repo
# root), because it expects ~/.config/rmpc/config.ron and ~/.config/mpd/mpd.conf
# to exist as symlinks into this repo.
#
# Readme.md next to this file explains why each step is here.

set -euo pipefail

rmpc_config="$HOME/.config/rmpc/config.ron"
mpd_config="$HOME/.config/mpd/mpd.conf"
mpd_socket="$HOME/.local/state/mpd/socket"
cache_dir="$HOME/.cache/rmpc"

say() { printf '\n\033[34m==> %s\033[0m\n' "$1"; }
die() { printf '\n\033[31mERROR: %s\033[0m\n' "$1" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this script targets macOS."
command -v brew >/dev/null 2>&1 || die "brew is not installed."
[ -f "$rmpc_config" ] || die "$rmpc_config is missing. Run the repo root 'install.sh -i' first."
[ -f "$mpd_config" ] || die "$mpd_config is missing. Run the repo root 'install.sh -i' first."

# 1. mpd is the server, rmpc the client, yt-dlp fetches the audio and ffmpeg /
#    ffprobe do its postprocessing. rmpc is bottled, so no Rust toolchain is
#    needed here (cargo install works too, but brew keeps it upgradeable).
say "1/5 packages"
for f in mpd rmpc yt-dlp ffmpeg; do
    if brew list --formula "$f" >/dev/null 2>&1; then
        printf '  %-8s %s\n' "$f" "$(brew list --versions "$f" | awk '{print $2}')"
    else
        brew install "$f"
    fi
done

# 2. rmpc probes the `python3` on PATH for mutagen before its YouTube path will
#    report healthy (`rmpc debuginfo`). The python inside brew's yt-dlp ships
#    mutagen, but that is not the interpreter rmpc checks, so it must exist for
#    the PATH python too. On this machine that is mise's python: a `latest` pin
#    means this step has to be repeated when mise bumps the version.
say "2/5 python mutagen for rmpc's dependency probe"
if python3 -c "import mutagen" >/dev/null 2>&1; then
    printf '  mutagen already present for %s\n' "$(command -v python3)"
else
    python3 -m pip install --user mutagen
    python3 -c "import mutagen" >/dev/null 2>&1 || die "mutagen still not importable by $(command -v python3)"
    printf '  installed mutagen into the user site of %s\n' "$(command -v python3)"
fi

# 3. rmpc downloads YouTube audio into cache_dir, which sits OUTSIDE mpd's
#    music_directory, and mpd only accepts queue entries from outside the music
#    directory when the client arrives over a local unix socket. So the socket
#    address is load bearing in BOTH configs; assert instead of assuming.
say "3/5 config assertions"
grep -q 'bind_to_address "~/\.local/state/mpd/socket"' "$mpd_config" \
    || die "$mpd_config must contain: bind_to_address \"~/.local/state/mpd/socket\""
printf '  mpd  : %s\n' "$(grep -E '^bind_to_address' "$mpd_config" | head -1)"
grep -q 'address: "~/\.local/state/mpd/socket"' "$rmpc_config" \
    || die "$rmpc_config must point address at the same socket path"
printf '  rmpc : %s\n' "$(grep -E '^\s+address:' "$rmpc_config" | head -1 | tr -s ' ')"
grep -q 'cache_dir: Some(' "$rmpc_config" \
    || die "$rmpc_config needs cache_dir set, rmpc refuses YouTube support without it"

# 4. Verify before wiring the service up.
say "4/5 verification"
printf '  yt-dlp  : %s\n' "$(yt-dlp --version)"
printf '  ffprobe : %s\n' "$(ffprobe -version 2>&1 | head -1 | awk '{print $1, $3}')"
rmpc_debug="$(rmpc debuginfo 2>&1 || true)"
printf '%s\n' "$rmpc_debug" | grep -qE "python-mutagen\s+installed" || die "rmpc does not see python-mutagen (see step 2)"
printf '%s\n' "$rmpc_debug" | grep -q "Unsupported commands \[\]" || die "rmpc reports unsupported commands: $rmpc_debug"
printf '  rmpc    : all runtime dependencies present\n'
mkdir -p "$cache_dir"

# 5. mpd as a login service. mpd resolves ~/.config/mpd/mpd.conf itself (no XDG
#    variables needed, unlike mopidy), so no anchor symlink is required here.
say "5/5 mpd service"
if brew services list 2>/dev/null | grep -qE '^mpd[[:space:]]+started'; then
    brew services restart mpd >/dev/null
elif pgrep -x mpd >/dev/null 2>&1; then
    printf '  NOTE: mpd is already running as a manual process (pid %s), not as a brew service.\n' "$(pgrep -x mpd | head -1)"
    printf '  It works now but will not come back after a reboot. To move it under brew services:\n'
    printf '    pkill -x mpd && brew services start mpd\n'
else
    brew services start mpd >/dev/null
fi
i=0
while [ "$i" -lt 15 ]; do
    [ -S "$mpd_socket" ] && break
    sleep 1
    i=$((i + 1))
done
[ -S "$mpd_socket" ] || die "mpd did not create $mpd_socket; see $HOME/.local/state/mpd/log"

printf '\n\033[32mDone.\033[0m Check it with:\n'
printf '  rmpc                        # the TUI client\n'
printf '  rmpc debuginfo              # dependency view\n'
printf '  rmpc searchyt -i "some song"  # YouTube search, pick from a list\n'
printf '  rmpc-library-import           # copy the newest download into ~/Music\n'
printf '  MPD_HOST=%s mpc status\n' "$mpd_socket"
