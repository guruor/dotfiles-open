## Mopidy instructions


### References
- https://www.digitalneanderthal.com/post/ncmpcpp/
- https://github.com/mopidy/mopidy-spotify/pull/65#issuecomment-295373011
- https://docs.mopidy.com/en/release-2.3/ext/backends/

Make sure to use same python version before installing all pip dependencies or use some common venv
```sh
# Below will install mopidy and some bundled extensions like File, Local and MPD
brew tap mopidy/mopidy
brew install mopidy
brew install gstreamer

# This will help with Youtube streaming, found this to be slow compared to Mopidy-YTMusic
# Has search option and auto play along with cache
python3 -m pip install --force-reinstall --no-cache-dir Mopidy-Youtube
python3 -m pip install --upgrade ytmusicapi
python3 -m pip install --upgrade --force-reinstall youtube-dl
python3 -m pip install --upgrade --force-reinstall yt_dlp
```

### Running
```sh 
# Use when need to run as service, it doesn't respect config in ~/.config/mopidy
brew services start mopidy
# Or directly run in terminal
mopidy

# To initially update local sqlite database for `Local` extension
mopidy local scan
```
### Debugging

Sometimes some extension gets auto disabled without any warning, To debug mopidy run:
```sh
mopidy -vvvv 2>&1 | tee mopidy.log
```

### Troubleshooting

#### Can't toggle media play/pause

With custom audio output setting, `mpc toggle` might not work
Reference: https://github.com/mopidy/mopidy/issues/1603#issuecomment-1013994538
This can be fixed by using host and port instead of `fifo` check here: https://wiki.archlinux.org/title/ncmpcpp#Enabling_visualization

### Troubleshooting mopidy-youtube

#### Freezes or slow music start

Make sure to change the `allow_cache = false`, caching is currently buggy

#### No module named 'yt_dlp'

```sh
python3 -m pip install --upgrade --force-reinstall yt_dlp
```

#### youtube-dl issue

You can find this error when using `youtube-dl` as youtube_dl_package.

```
Unable to extract uploader id; please report this issue on https://yt-dl.org/bug
```

Make sure to upgrade to latest `youtube-dl`, using below command
```sh
python3 -m pip install --upgrade --force-reinstall youtube-dl
```
