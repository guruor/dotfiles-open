## Installation

Setup article for linux: https://shom.dev/start/using-kanata-to-remap-any-keyboard
Official doc: https://github.com/jtroo/kanata

```sh
cargo install kanata

# For specific version
cargo install kanata --git https://github.com/jtroo/kanata --tag v1.6.0-prerelease-3
```

```sh
# On mac we need to run it with sudo
sudo kanata -c ~/.config/kanata/kanata.kbd
```

## System tray

For Linux and Windows there is a system tray available
https://github.com/rszyma/kanata-tray
Check the setup process and config in my dotfiles

```sh

cargo install kanata --git https://github.com/jtroo/kanata --tag v1.6.0-prerelease-3
git clone https://github.com/rszyma/kanata-tray /tmp/kanata-tray
cd /tmp/kanata-tray
# Check the golang version with the project go.mod
asdf install golang 1.21.9
asdf local golang 1.21.9
GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 GO111MODULE=on go build -ldflags "-s -w -X 'main.buildVersion=latest' -X 'main.buildHash=$(git rev-parse HEAD)' -X 'main.buildDate=$(date -u)'" -trimpath -o dist/kanata-tray
cp ./dist/kanata-tray ~/.local/bin
```
