#!/usr/bin/env bash
#
# Mopidy setup for macOS. Idempotent: re-run it any time, including after
# `brew upgrade mopidy`, which wipes everything step 3 adds.
#
# Run it AFTER the dotfiles themselves are linked (`./install.sh -i` at the repo
# root), because it points the macOS service at the linked config and expects
# ~/.config/mopidy/mopidy.conf to exist.
#
# Readme.md next to this file explains why each step is here.

set -euo pipefail

config_target="$HOME/.config/mopidy/mopidy.conf"
anchor_dir="$HOME/Library/Application Support/mopidy"
anchor="$anchor_dir/mopidy.conf"
mopidy_bin="$(brew --prefix 2>/dev/null || echo /opt/homebrew)/bin/mopidy"

say() { printf '\n\033[34m==> %s\033[0m\n' "$1"; }
die() { printf '\n\033[31mERROR: %s\033[0m\n' "$1" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this script targets macOS (it fixes a launchd config path quirk)."
command -v brew >/dev/null 2>&1 || die "brew is not installed."
[ -f "$config_target" ] || die "$config_target is missing. Run the repo root 'install.sh -i' first."

# 1. Mopidy and its GStreamer stack. The gstreamer formula is the single owner
#    of the codecs and of the pygobject bindings built for the same Python;
#    never install gst-* / gst-python separately, that is what used to split.
say "1/6 mopidy from the official tap"
brew tap mopidy/mopidy >/dev/null
brew list --formula mopidy >/dev/null 2>&1 || brew install mopidy
brew list --formula gstreamer >/dev/null 2>&1 || brew install gstreamer

mopidy_py="$(brew --prefix mopidy)/libexec/bin/python"
[ -x "$mopidy_py" ] || die "no interpreter at $mopidy_py"

# 2. The anchor symlink. launchd runs the service without the XDG_* variables,
#    so mopidy resolves its default config path through platformdirs to
#    "~/Library/Application Support/mopidy/mopidy.conf". Without this link the
#    service loads NO config at all and falls back to the platformdirs data_dir,
#    which is a different (empty) library than the CLI scans into.
say "2/6 config anchor for the launchd service"
mkdir -p "$anchor_dir"
ln -sfn "$config_target" "$anchor"
printf '  %s -> %s\n' "$anchor" "$(readlink "$anchor")"

# 3. Extensions go INSIDE mopidy's venv, pinned to the Python that GStreamer was
#    built for. Installing them into system python3 is what broke this setup
#    before. Two traps this step avoids:
#      - `uv pip install mopidy-youtube` resolves Mopidy's PyPI metadata, which
#        requires pygobject>=3.50 and pycairo, so uv builds a SECOND pygobject in
#        this venv that shadows brew's pygobject3. Hence --no-deps plus an
#        explicit dependency list (mopidy-youtube's own Requires-Dist).
#      - setuptools>=81 drops pkg_resources, which mopidy-youtube imports.
say "3/6 extensions into mopidy's venv"
command -v uv >/dev/null 2>&1 || die "uv is required (brew install uv): mopidy's venv ships without pip."
uv pip install --python "$mopidy_py" "setuptools<81"
uv pip install --python "$mopidy_py" --no-deps mopidy-youtube
uv pip install --python "$mopidy_py" yt-dlp requests beautifulsoup4 cachetools

# 4. Verify before wiring anything up.
say "4/6 verification"
"$mopidy_py" -c "import gi; gi.require_version('Gst','1.0'); from gi.repository import Gst; Gst.init(None); print('  GStreamer via gi :', Gst.version_string())"
"$mopidy_py" -c "from importlib.metadata import version; print('  mopidy-youtube   :', version('mopidy-youtube')); print('  yt-dlp           :', version('yt-dlp'))"
gi_path="$("$mopidy_py" -c 'import gi; print(gi.__file__)')"
if printf '%s' "$gi_path" | grep -q "^$(brew --prefix 2>/dev/null || echo /opt/homebrew)/"; then
    printf '  gi (brew)        : %s\n' "$gi_path"
else
    die "gi resolves to $gi_path instead of brew's pygobject3: this venv holds a duplicate pygobject. Remove it with: uv pip uninstall --python $mopidy_py pygobject pycairo"
fi
"$mopidy_bin" config >/dev/null || die "mopidy rejects $config_target"

# 5. Local library. The daemon and the CLI must not write the same SQLite file at
#    the same time, so scan while the daemon is stopped and start it afterwards.
say "5/6 local library scan (daemon stopped)"
brew services stop mopidy >/dev/null 2>&1 || true
"$mopidy_bin" local scan 2>&1 | tail -3 || true

# 6. Service on 6600 (MPD protocol) and 6680 (HTTP RPC), started at login.
say "6/6 service"
brew services restart mopidy >/dev/null
i=0
while [ "$i" -lt 15 ]; do
    lsof -nP -iTCP:6600 -sTCP:LISTEN >/dev/null 2>&1 && break
    sleep 1
    i=$((i + 1))
done
lsof -nP -iTCP:6600 -sTCP:LISTEN >/dev/null 2>&1 || die "nothing is listening on 6600; see /opt/homebrew/var/log/mopidy.log"

printf '\n\033[32mDone.\033[0m Check it with:\n'
printf '  mpc status\n  mpc search any music | head\n  brew services list | grep mopidy\n'
