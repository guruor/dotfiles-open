### The Voidrice rice
 
Inspired by [Luke Smith](https://lukesmith.xyz)'s dotfiles

![MacOs](./screenshots/macos-main.png?raw=true "MacOS Preview")

#### Platform Specific Programs

| App type             | Mac                                       | Linux                                             |
|----------------------|-------------------------------------------|---------------------------------------------------|
| Window Manager       | [Yabai](.config/yabai/)                   | [dwm](https://github.com/G0V1NDS/dmenu)           |
| KeyMapper            | [Karabiner Elements](.config/karabiner)   | setxkbmap                                         |
| General key binder   | [skhd](.config/skhd)                      | sxhkd                                             |
| Application launcher | [Raycast](https://www.raycast.com/)                                   | [dmenu](https://github.com/G0V1NDS/dmenu)         |
| Primary terminal     | [kitty](.config/kitty)                    | [st](https://github.com/G0V1NDS/st)               |
| Statusbar            | -                                         | [dwmblocks](https://github.com/G0V1NDS/dwmblocks) |
| Clipboard manager    | [Maccy](https://github.com/p0deje/Maccy)  | [clipmenu](https://github.com/cdown/clipmenu)     |
| Notification daemon  | -                                         | [dunst](.config/dunst)                            |

#### Cross-platform programs

- Settings for:
	- [Nvim](.config/nvim/) (text editor)
	- [Kitty](.config/kitty/)/[Wezterm](.config/wezterm/)/[Alacritty](.config/alacritty/) (terminal emulator)
	- [Zsh](.config/zsh/) (shell)
	- [Tmux](.config/tmux/)
	- [LF](.config/lf/) (file manager)
	- [mpd](.config/mpd/)/[ncmpcpp](.config/ncmpcpp/)/[mopidy](.config/mopidy/) (music)
	- [Syncthing](https://github.com/syncthing/syncthing) (Network file sync)
	- Other userful tools:
		- [Starship](.config/starship.toml), [exa](https://github.com/ogham/exa), [zoxide](https://github.com/ajeetdsouza/zoxide), [bat](.config/bat), [fzf](https://github.com/junegunn/fzf), [Bottom](.config/bottom/), [delta](.config/delta/), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](.config/fd), [lazygit](.config/lazygit), [lazydocker](https://github.com/jesseduffield/lazydocker)
	- Very useful scripts are in [~/.local/bin/](.local/bin/)

#### Install these dotfiles and all dependencies

There is an [install.sh](./install.sh) in the repo directory for quickly symlink the dotfiles but I would advice you to go through the required config and move the helpful component to your setup.

For personal configs maintained I have `Private` repo, where I keep my personal config those configs are symlinked into this repo.

For few programs like `mopidy`, where you would often face some setup issues, Readme file is added inside individual program config directory.

#### Other recommanded programs

##### Mac Specific
[Homerow](https://github.com/dexterleng/homerow), [Itsycal](https://github.com/sfsam/Itsycal), [Hidden Bar](https://github.com/dwarvesf/hidden), [MonitorControl](https://github.com/MonitorControl/MonitorControl)

##### Common
[Vimium](https://github.com/philc/vimium), [Bitwarden](https://bitwarden.com/download/), [Maestral](https://github.com/samschott/maestral), [xBrowserSync](https://github.com/xbrowsersync/app), [Flameshot](https://github.com/flameshot-org/flameshot) 
