## System tray for Kanata

Repo: https://github.com/rszyma/kanata-tray

### Installation

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

### Symlinking the config for Mac

```sh

ln -sf $HOME/.config/kanata-tray/kanata-tray.toml $HOME/Library/Application\ Support/kanata-tray/kanata-tray.toml
```

### Starting the service

```sh
./mac-service --start
```
