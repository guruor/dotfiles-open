## Mopidy instructions

Mopidy is the MPD-protocol server for this setup. It replaced `mpd` (the service is
retired, config kept): it serves local files through the `local` extension and YouTube
through `youtube`, to `ncmpcpp` / `mpc` on port 6600, plus an HTTP RPC on 6680.
To go back to plain mpd: `brew services stop mopidy && brew services start mpd`.

### References
- https://www.digitalneanderthal.com/post/ncmpcpp/
- https://github.com/mopidy/mopidy-spotify/pull/65#issuecomment-295373011
- https://docs.mopidy.com/en/release-2.3/ext/backends/
- https://docs.mopidy.com/en/stable/installation/macos/

### Fresh machine

`~/.config/mopidy/install.sh` does all of it and verifies itself. Run it after the
dotfiles are linked (repo root `./install.sh -i`), since it needs `~/.config/mopidy/`
to already point into the repo. It is idempotent, so run it again after any
`brew upgrade mopidy`.

What it does, and why:

1. `brew tap mopidy/mopidy` then `brew install mopidy`. `gstreamer` arrives as a
   dependency and is the **single owner** of the codecs and of the pygobject bindings
   built for the same Python. Do not install `gst-plugins-*`, `gst-libav` or
   `gst-python` separately: the old split is what caused the two-packages-disagreeing
   breakage.
2. **The config anchor.** `brew services` runs `mopidy` with no `--config`, so mopidy
   resolves its default config path through `platformdirs`. With the XDG variables from
   these dotfiles set (interactive shell) that is `~/.config/mopidy/mopidy.conf`; under
   launchd there are no XDG variables, so it is
   `~/Library/Application Support/mopidy/mopidy.conf`. Without the anchor symlink the
   *service* loads no config at all and runs on a different, empty library than the CLI
   uses. That is the real reason for the old note "it doesn't respect config in
   ~/.config/mopidy".
3. Extensions are installed **into mopidy's own venv**, with the interpreter
   GStreamer was built against. Never `python3 -m pip install` them: that targets
   system python3 while mopidy runs in brew's venv, which is what broke this setup
   before. `setuptools<81` is required because `mopidy-youtube` imports
   `pkg_resources`, removed in newer setuptools.
   ```sh
   uv pip install --python "$(brew --prefix mopidy)/libexec/bin/python" "setuptools<81"
   uv pip install --python "$(brew --prefix mopidy)/libexec/bin/python" --no-deps mopidy-youtube
   uv pip install --python "$(brew --prefix mopidy)/libexec/bin/python" yt-dlp requests beautifulsoup4 cachetools
   ```
   `--no-deps` is deliberate. A plain `uv pip install mopidy-youtube` resolves its
   `Mopidy>=3.1` requirement, and Mopidy's PyPI metadata requires `pygobject>=3.50`
   and `pycairo`: uv then **builds a second pygobject inside the venv** that shadows
   brew's `pygobject3` (minutes of compiling, and a binding that can drift from the
   installed GStreamer). The real dependencies are listed explicitly instead.
   This does not disturb mopidy's own pinned set (pydantic, pykka, cyclopts); check with
   `uv pip install --python ... --dry-run mopidy-youtube` if in doubt.
4. Verify before trusting it:
   ```sh
   "$(brew --prefix mopidy)/libexec/bin/python" -c \
     "import gi; gi.require_version('Gst','1.0'); from gi.repository import Gst; Gst.init(None); print(Gst.version_string())"
   ```
   (`Gst.init()` must run before `Gst.version_string()`, otherwise pygobject raises
   `NotInitialized` even though the bindings loaded fine.)
   An extension that is broken is silently skipped on startup, so confirm with
   `mopidy config` and then a real search.
5. Local library: **stop the daemon first**, because the CLI and the daemon write the
   same SQLite file and will otherwise disagree (symptoms: `no such table: tracks`,
   or search returning YouTube results only).
   ```sh
   brew services stop mopidy && mopidy local scan && brew services start mopidy
   ```

### Running

```sh
brew services start mopidy   # starts at login (RunAtLoad), logs to /opt/homebrew/var/log/mopidy.log
mopidy                       # or run in the foreground of a terminal
mpc status                   # client check
ncmpcpp                      # hotkey: meh - m (see .config/skhd/skhdrc)
```

Mopidy is a boot service: nothing else should start it. The skhd binding used to run
`mopidy &` before `ncmpcpp`, which now spawns a second instance that cannot bind 6600.

### Debugging

```sh
mopidy -vvvv 2>&1 | tee mopidy.log        # foreground, verbose; it prints "Audio output set to ..."
brew services restart mopidy && tail -f /opt/homebrew/var/log/mopidy.log
```

### Troubleshooting

#### `ncmpcpp` cannot connect

`ncmpcpp` and `mpc` both use libmpdclient, and `localhost` resolves to `::1` before
`127.0.0.1`. Mopidy is configured to bind `127.0.0.1` only (deliberate: `::` would
listen on the LAN), so `::1` is refused; clients that fall back to IPv4 connect fine.
If a client does not fall back, pin `mpd_host = 127.0.0.1` in its config. Check the
server side with `lsof -nP -iTCP:6600 -sTCP:LISTEN`.

#### Can't toggle media play/pause

With a custom audio output setting, `mpc toggle` might not work.
Reference: https://github.com/mopidy/mopidy/issues/1603#issuecomment-1013994538
Using host and port instead of `fifo`: https://wiki.archlinux.org/title/ncmpcpp#Enabling_visualization

#### Visualizer shows nothing

`visualizer_data_source = "localhost:5555"` needs mopidy to emit a raw PCM feed with
`[audio] output` teeing into `udpsink`. Verify mopidy actually opened the socket:
`lsof -nP -a -iUDP -p $(lsof -nP -iTCP:6600 -sTCP:LISTEN -t)` must show a UDP socket
while playing. If it does not, the feed is dead regardless of what ncmpcpp does.

### Troubleshooting mopidy-youtube

#### Freezes or slow music start

Make sure to change the `allow_cache = false`, caching is currently buggy

#### No module named 'yt_dlp'

It is installed with the extension into mopidy's venv; re-run step 3 of `install.sh`,
do not use `python3 -m pip`:
```sh
uv pip install --python "$(brew --prefix mopidy)/libexec/bin/python" yt-dlp
```

#### youtube-dl issue

You can find this error when using `youtube-dl` as youtube_dl_package.
```
Unable to extract uploader id; please report this issue on https://yt-dl.org/bug
```
Use `yt_dlp` instead (the default in this config) and keep it current:
```sh
uv pip install --python "$(brew --prefix mopidy)/libexec/bin/python" --upgrade yt-dlp
```

#### `no such table: tracks` or `no such table: search`

The daemon is using a different `library.db` than the scan wrote (see step 2), or it was
started while a scan replaced the file. Verify which file the daemon holds open:
`lsof -p $(lsof -nP -iTCP:6600 -sTCP:LISTEN -t) | grep library.db` should show
`~/.local/share/mopidy/local/library.db`, then re-run the scan with the daemon stopped.

#### Duplicate pygobject inside mopidy's venv

Check where `gi` resolves from; it must be brew's pygobject3, not the venv:
```sh
/opt/homebrew/opt/mopidy/libexec/bin/python -c "import gi; print(gi.__file__)"
# good: /opt/homebrew/opt/pygobject3/lib/python3.14/site-packages/gi/__init__.py
# bad : /opt/homebrew/Cellar/mopidy/*/libexec/lib/python3.14/site-packages/gi/__init__.py
uv pip uninstall --python /opt/homebrew/opt/mopidy/libexec/bin/python pygobject pycairo
```
`install.sh` fails loudly if it finds this, so it should not survive a re-run.
