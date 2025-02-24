### The Voidrice rice

Inspired by [Luke Smith](https://lukesmith.xyz)'s dotfiles

![MacOS](./screenshots/macos-main.png?raw=true "MacOS Preview")

#### Platform Specific Programs

| App type             | Mac                                                                               | Linux                                               |
| -------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------- |
| Window Manager       | [Yabai](.config/yabai/)                                                           | [dwm](https://github.com/guruor/dmenu)              |
| KeyMapper            | [kanata](https://github.com/jtroo/kanata)/[Karabiner Elements](.config/karabiner) | [kanata](https://github.com/jtroo/kanata)/setxkbmap |
| General key binder   | [skhd](.config/skhd)/ [LeaderKey](.config/leader_key)                             | sxhkd                                               |
| Application launcher | [Raycast](https://www.raycast.com/)                                               | [dmenu](https://github.com/guruor/dmenu)            |
| Primary terminal     | [kitty](.config/kitty)                                                            | [st](https://github.com/guruor/st)                  |
| Statusbar            | -                                                                                 | [dwmblocks](https://github.com/guruor/dwmblocks)    |
| Clipboard manager    | [Maccy](https://github.com/p0deje/Maccy)                                          | [clipmenu](https://github.com/cdown/clipmenu)       |
| Notification daemon  | -                                                                                 | [dunst](.config/dunst)                              |

#### Cross-platform programs

- Settings for:
    - [Nvim](.config/nvim/) (text editor)
    - [Kitty](.config/kitty/)/[Wezterm](.config/wezterm/)/[Alacritty](.config/alacritty/) (terminal emulator)
    - [Zsh](.config/zsh/) (shell)
    - [Tmux](.config/tmux/)
    - [Yazi](.config/yazi/)/[LF](.config/lf/) (terminal file manager)
    - [mpd](.config/mpd/)/[ncmpcpp](.config/ncmpcpp/)/[mopidy](.config/mopidy/) (music)
    - [Syncthing](https://github.com/syncthing/syncthing) (Network file sync)
    - Other useful tools:
        - [Starship](.config/starship.toml), [eza](https://github.com/eza-community/eza), [zoxide](https://github.com/ajeetdsouza/zoxide), [tldr](https://github.com/tealdeer-rs/tealdeer), [fzf](https://github.com/junegunn/fzf), [Bottom](.config/bottom/), [delta](.config/delta/), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](.config/fd), [lazygit](.config/lazygit), [lazydocker](https://github.com/jesseduffield/lazydocker), [bat](.config/bat)
    - Very useful scripts are in [~/.local/bin/](.local/bin/)

#### Install these dotfiles and all dependencies

There is an [install.sh](./install.sh) in the repo directory for quickly symlink the dotfiles but I would advice you to go through the required config and move the helpful component to your setup.

For personal configs maintained I have `Private` repo, where I keep my personal config those configs are symlinked into this repo.

For few programs like `mopidy`, where you would often face some setup issues, Readme file is added inside individual program config directory.

#### Other recommended programs

##### Mac Specific

[Homerow](https://github.com/dexterleng/homerow), [Itsycal](https://github.com/sfsam/Itsycal), [Hidden Bar](https://github.com/dwarvesf/hidden), [MonitorControl](https://github.com/MonitorControl/MonitorControl), [TomatoBar](https://github.com/ivoronin/TomatoBar), [CheatSheet](https://cheatsheet-mac.en.softonic.com/mac), [Caffeine](https://github.com/domzilla/Caffeine)

##### Common

[uBlock Origin](https://github.com/gorhill/uBlock), [Surfingkeys](https://github.com/brookhong/Surfingkeys)/[Vimium](https://github.com/philc/vimium), [Bitwarden](https://bitwarden.com/download/), [Ente Auth](https://github.com/ente-io/ente#ente-auth), [Maestral](https://github.com/samschott/maestral), [Floccus](https://github.com/floccusaddon/floccus)/[xBrowserSync](https://github.com/xbrowsersync/app), [Flameshot](https://github.com/flameshot-org/flameshot), [Espanso](https://github.com/espanso/espanso), [keep-alive](https://github.com/stigoleg/keep-alive), [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic)
