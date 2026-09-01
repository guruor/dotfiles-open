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

#### Secret scanning

Gitleaks blocks staged secrets through `.githooks/pre-commit` and scans every
commit introduced by a GitHub push or pull request. The private submodule has
its own independent scan; the public workflow does not initialize or inspect
its working tree.

Install Gitleaks and enable the versioned hook before committing if `install.sh`
has not already configured it:

```sh
brew install gitleaks
git config core.hooksPath .githooks
```

The hook fails closed when Gitleaks is unavailable. Findings are redacted, and
`gitleaks:allow` comments do not bypass the local or GitHub checks. Common
credential and private-key filenames are rejected even when their contents do
not match a known token format.

#### Historical secret review

The generic `gitleaks-history-cleanup` command scans any local Git repository,
records exact false-positive fingerprints, or creates and selectively rewrites
a mirror of a chosen remote:

```sh
gitleaks-history-cleanup
gitleaks-history-cleanup scan /path/to/repository
gitleaks-history-cleanup scan /path/to/repository --strict
gitleaks-history-cleanup ignore /path/to/repository
gitleaks-history-cleanup clean /path/to/repository --remote origin
```

`scan` is read-only and returns status 1 when findings exist. Repository policy
uses `.gitleaks.toml` and `.gitleaksignore` by default; `--strict` instead uses
the maintained default rules and ignores repository bypasses. `ignore` uses
`fzf` to append only selected finding fingerprints to `.gitleaksignore`.

`clean` clones the selected remote into a mode-`0700` mirror, presents only
redacted path/rule metadata in `fzf`, removes explicitly selected paths after a
typed confirmation, and rescans every rewritten ref. A selected path that is
absent from every branch tip is removed completely. When clean versions remain
at branch tips, their blobs are checked with strict default rules, the old path
history is purged, and each clean tip is restored in one explicit sanitized
commit. A branch-tip copy that still triggers Gitleaks is listed before
confirmation and remains removed on that branch. It never pushes. A
successfully rewritten mirror is retained with a suggested
`git push --force --mirror` command so it can be inspected first. Because the
mirror is bare, the command prints a short history view, one absence check per
removed path, and an optional normal-checkout command instead of suggesting
`git status` directly. Rotate exposed credentials before pushing and remove the
mirror afterward; remote caches,
forks, pull-request refs, LFS objects, backups, and other clones may still retain
old data.

Branch-tip preservation uses the repository's active Gitleaks policy, while a
separate strict-default scan checks secret content and rename side effects. A
selected custom-policy violation is therefore removed from every branch and is
never restored merely because its contents pass default rules.

Cleanup rewrites selected paths across every mirrored branch and tag but does
not delete branch refs. Obsolete branches must be deleted explicitly as a
separate repository-management decision.

History rewrites can expose a renamed destination that Gitleaks did not flag in
the original pure-rename diff. Newly surfaced findings fail verification; rerun
with each reported exact path supplied as `--path PATH` to remove the complete
rename chain.

Git submodules are independent repositories. Cleaning and force-pushing a
submodule updates only its own remote; the parent repository still needs a
normal commit that records the rewritten submodule commit. When cleanup runs
inside a submodule checkout, the command prints the parent `git add` and status
commands separately.

GitHub branch protection must be disabled temporarily before rewritten history
can be force-pushed. A mirror push is expected to reject GitHub's read-only
`refs/pull/*` refs; retry until those are the only failures, then contact GitHub
Support when sensitive data remains referenced by affected pull requests.

#### Other recommended programs

##### Mac Specific

[Homerow](https://github.com/dexterleng/homerow), [Itsycal](https://github.com/sfsam/Itsycal), [Hidden Bar](https://github.com/dwarvesf/hidden), [MonitorControl](https://github.com/MonitorControl/MonitorControl), [TomatoBar](https://github.com/ivoronin/TomatoBar), [CheatSheet](https://cheatsheet-mac.en.softonic.com/mac), [Caffeine](https://github.com/domzilla/Caffeine)

##### Common

[uBlock Origin](https://github.com/gorhill/uBlock), [Surfingkeys](https://github.com/brookhong/Surfingkeys)/[Vimium](https://github.com/philc/vimium), [Bitwarden](https://bitwarden.com/download/), [Ente Auth](https://github.com/ente-io/ente#ente-auth), [Maestral](https://github.com/samschott/maestral), [Floccus](https://github.com/floccusaddon/floccus)/[xBrowserSync](https://github.com/xbrowsersync/app), [Flameshot](https://github.com/flameshot-org/flameshot), [Espanso](https://github.com/espanso/espanso), [keep-alive](https://github.com/stigoleg/keep-alive), [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic)
