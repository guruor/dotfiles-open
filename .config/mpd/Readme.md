# Music Player Daemon (mpd) setup
 
## Installation
```sh
brew install mpd mpc
```

## Troubleshooting
 
### No configuration file found
MPD requires some initial files to start the player.
In case you face `exception: No configuration file found`, try below snippet:

```sh
ln -s ~/.config/mpd ~/.mpd;
cd ~/.mpd;
touch mpd.db mpd.log mpd.pid mpdstate
```
### Missing recently added music files in `ncmpcpp`

`mpc update`
