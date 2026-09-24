# rmpc + mpd, with YouTube

Replaces the mopidy stack for listening. Measured on this machine while playing:

| stack | server | client | total |
|---|---|---|---|
| mpd + rmpc (this) | mpd 31 MB | rmpc 28-48 MB | ~60-80 MB |
| mopidy + ncmpcpp (retired) | mopidy 78 MB idle, 114 MB playing | ncmpcpp 22 MB | ~100-136 MB |

`rmpc` is an ncmpcpp-inspired Rust TUI client. It speaks the MPD protocol to `mpd`;
it is not a mopidy client and mopidy cannot serve it.

## Pieces and who owns what

| thing | role |
|---|---|
| `mpd` | the server (C). Owns the library in `~/Music` and the queue. rmpc only connects to it and does NOT start it, so mpd must already be running (brew service) or rmpc has nothing to talk to. |
| `rmpc` | the client (Rust TUI). Also downloads YouTube itself. |
| `yt-dlp` | fetches YouTube audio into rmpc's `cache_dir`. |
| `ffmpeg` / `ffprobe` | yt-dlp postprocessing, plus rmpc's own checks. |
| `python3` + `mutagen` | rmpc's dependency probe for metadata/artwork. |

## Install on a fresh machine

1. `brew install mpd rmpc yt-dlp ffmpeg` (all bottled, no Rust toolchain needed).
2. `python3 -m pip install --user mutagen`.
   rmpc runs the `python3` on PATH and looks for `mutagen`; brew's yt-dlp bundles one,
   but that is a different interpreter. On this machine the PATH python is mise's, and
   its `latest` pin means this step must be repeated whenever mise bumps python.
3. `./install.sh -i` at the repo root, which links `config.ron` and `mpd.conf` from here
   into `~/.config`.
4. `.config/rmpc/install.sh` (this directory) does the package install, the mutagen check,
   both config assertions and the mpd service.
5. `brew services start mpd`. mpd resolves `~/.config/mpd/mpd.conf` by itself, so unlike
   mopidy it needs no anchor symlink in `~/Library/Application Support`.
6. Verify: `rmpc debuginfo` (everything `installed`, `Unsupported commands []`), then
   `MPD_HOST=~/.local/state/mpd/socket mpc status`.

## The two config values that matter

Both live in this repo and are load bearing together:

* `.config/mpd/mpd.conf`: `bind_to_address "~/.local/state/mpd/socket"`.
  rmpc downloads YouTube audio into `cache_dir`, which is outside mpd's
  `music_directory`, and mpd only accepts queue entries from outside the music directory
  when the client connects over a **local unix socket**. Over TCP mpd answers
  `No such song`. The commented TCP line is there for other clients once nothing else
  needs port 6600.
* `.config/rmpc/config.ron`: `address` at that same socket, plus
  `cache_dir: Some("~/.cache/rmpc")`. rmpc refuses YouTube support outright without a
  `cache_dir`. Both fields are tilde-expanded by rmpc, so they stay portable.

## YouTube

Commands in the TUI, entered after `:` (command mode; `?` shows all keybinds):

| command | what it does |
|---|---|
| `searchyt -i <query>` | search, then pick from a list |
| `searchyt <query>` | queue the first match |
| `addyt <url>` | queue a specific video or playlist |
| `od` | downloads modal: progress, cancel, redownload |

The audio lands in `~/.cache/rmpc/youtube/<video-id>.<ext>` and that absolute path is
what gets queued, so playback is local and gapless. Verified here:
`rmpc searchyt "AURORA Runaway"` downloaded `d_HlPboLRL8.opus` (4.1 MB) and queued it.

`rmpc searchyt`, `addyt`, `play`, `pause`, `volume`, `queue` and `debuginfo` also work as
plain CLI commands, which is handy from a script or a hotkey. In a non-TTY pipe the CLI
holds the terminal open while a download runs, so wrap it in a timeout if scripting it.

## Getting a YouTube download into your library

rmpc never writes to `~/Music`. It downloads to `~/.cache/rmpc/youtube/<video-id>.<ext>`
and queues that cache path, so YouTube listening leaves the library untouched, and the
cache is not a library either: files are named after the video id and nothing prunes them.
To keep something, import it:

```bash
rmpc-library-import                 # newest download in the cache
rmpc-library-import <video-id>      # a specific one
rmpc-library-import --list          # cache contents, and what is already imported
rmpc-library-import --dry-run <id>  # show the name it would use, write nothing
rmpc-library-import --move <id>     # move instead of hard linking
```

It names the file `<channel> - <title>.<ext>`, writes it into `~/Music/YouTube/` and
rescans. rmpc's downloads carry no metadata tags, so the name is resolved from YouTube by
video id and falls back to the raw id when offline. It **hard links** by default: the file
gets a second name at no extra disk cost, and the cache path mpd is playing or holding in
its queue stays valid. Prune the cache copy later.

Do not symlink the cache into `~/Music` instead. mpd follows such links
(`follow_outside_symlinks "yes"` here), so the same file lands in the database twice under
an unreadable video-id name, and pruning the cache takes library entries with it. An
`~/Music/YouTube/youtube -> ~/.cache/rmpc/youtube` link does exactly that and was removed
in favour of the import above.

Files reaching `~/Music` by any means need a rescan afterwards, because macOS mpd has no
`auto_update` (its log says `inotify: auto_update was disabled. enable during compilation
phase`). Any of these work, and they are the same operation:

| where | command |
|---|---|
| rmpc TUI | `<C-u>` (config.ron binds it to `Update`) |
| any shell | `rmpc update`, or `mpc update <a dir under music_directory>` |
| rmpc TUI | `<C-U>` is `Rescan`, the heavier full re-read |

## Caveats, all observed on this machine

* **Livestreams never finish.** The first hit for a query like "lofi hip hop radio" is a
  24/7 HLS livestream: yt-dlp downloads segments forever, no file ever appears, and mpd
  answers `No such song` because rmpc tried to queue a path that does not exist yet.
  Use `searchyt -i` and pick a normal upload.
* **A failed or killed download leaves a `*.part` file** in the cache (8 MB orphan seen
  here). Safe to delete. rmpc's own docs warn that adding a playlist cannot be cancelled
  except by quitting rmpc, which is what produces these.
* **The cache grows with listening** and is never pruned for you. It is not in the repo
  and not indexable, so delete freely.
* **macOS mpd has no `auto_update`** (inotify is Linux-only, its log says so). Files
  added to `~/Music` by other means need `:update` in rmpc or `mpc update`.
* Downloading never touches `~/Music`, so YouTube listening does not grow the library or
  its database.
* Any local file can also be queued directly by absolute path over the socket
  (`mpc add /some/path.opus` works, verified) if you ever want to bypass rmpc's downloader.
