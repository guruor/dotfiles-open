#!/bin/bash
# This script clones and sets up dotfiles, requiring Bitwarden and yq.
# Run this script directly in shell using:
# curl -s https://raw.githubusercontent.com/guruor/dotfiles-open/refs/heads/master/.local/bin/dot-setup.sh | bash -s -- --confirm

# Exit on error
set -e

# Constants
DEFAULT_GIT_USER="guruor"
DEFAULT_DOTFILES_REPO="dotfiles-open"
DEFAULT_DOTFILES_DIR="$HOME/voidrice"
GIT_PRIVATE_HOST="github-personal"
# BW_GITHUB_ITEM_NAME="Github Govind Personal"
BW_GITHUB_ITEM_ID="95a44651-2d37-407a-a1b6-ad8900c6c680"
BW_GITHUB_ITEM_NOTES_YAML_KEY=".tokens.personal_access_token"

# Function to detect the platform (macOS or Debian-based Linux) and architecture
detect_platform() {
  UNAME_OUTPUT=$(uname -s)
  ARCH=$(uname -m)
  case "$UNAME_OUTPUT" in
  Linux*)
    PLATFORM="linux"
    if [[ "$ARCH" == "aarch64" || "$ARCH" == "armv7l" ]]; then
      ARCH="arm"
    else
      ARCH="x86"
    fi
    ;;
  Darwin*)
    PLATFORM="macos"
    ;;
  *)
    echo "Unsupported platform: $UNAME_OUTPUT"
    exit 1
    ;;
  esac
}

# Function to install Homebrew on macOS or Linux
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    if [ "$PLATFORM" = "macos" ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      setup_homebrew_env_macos
    elif [ "$PLATFORM" = "linux" ]; then
      sudo apt-get update && sudo apt-get install -y build-essential procps file git
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  else
    # Set up the brew environment if already installed
    echo "Homebrew is already installed."
    if [ "$PLATFORM" = "macos" ]; then
      setup_homebrew_env_macos
    elif [ "$PLATFORM" = "linux" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi
}

# Function to set up Homebrew environment for macOS
setup_homebrew_env_macos() {
  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)" # for macOS on ARM
  elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)" # for macOS on Intel
  fi
}

# Function to install necessary tools using Homebrew
# Function to install necessary tools on macOS
install_dependencies_macos() {
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew on macOS..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    setup_homebrew_env_macos
  else
    echo "Homebrew is already installed."
    setup_homebrew_env_macos
  fi
  echo "Installing required packages with Homebrew..."
  brew install bitwarden-cli yq
}

install_dependencies_linux() {
  sudo apt-get update
  sudo apt-get install -y build-essential procps file git
  if [[ "$ARCH" == "x86" ]]; then
    # If the architecture is x86, attempt to install Homebrew and dependencies.
    if ! command -v brew &>/dev/null; then
      echo "Installing Homebrew on x86 Linux..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      brew install bitwarden-cli yq
    else
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      brew install bitwarden-cli yq
    fi
  elif [[ "$ARCH" == "arm" ]]; then
    # ARM Linux doesn't support Homebrew, use apt for dependencies.
    echo "ARM architecture detected. Installing packages using apt..."
    sudo snap install yq
    sudo apt-get install npm
    sudo npm install -g @bitwarden/cli
  fi
}

# Function to prompt for Bitwarden credentials
prompt_for_bitwarden_credentials() {
  read -p "Bitwarden email: " BW_EMAIL
  read -s -p "Bitwarden master password: " BW_PASSWORD
  echo ""
}

# Function to login to Bitwarden
bitwarden_login() {
  if ! bw login --check &>/dev/null; then
    BW_SESSION="$(bw login --raw "$BW_EMAIL" "$BW_PASSWORD")"
    export BW_SESSION
  fi
}

# Function to unlock Bitwarden
bitwarden_unlock() {
  if ! bw unlock --check &>/dev/null; then
    BW_SESSION="$(bw unlock --raw "$BW_PASSWORD")"
  fi
}

# Function to get GitHub personal access token
get_github_token() {
  echo "Fetching GitHub personal access token from Bitwarden..."
  github_personal_token=$(bw get item "${BW_GITHUB_ITEM_ID}" | yq ".notes | fromjson | ${BW_GITHUB_ITEM_NOTES_YAML_KEY}")
}

# Function to configure Git
configure_git() {
  echo "Configuring Git credential caching..."
  git config --global credential.helper 'cache --timeout=3600'
}

# Function to clone the repository
clone_dotfiles_repo() {
  echo "Cloning the dotfiles repository..."
  git clone --recurse-submodules -c core.symlinks=true "https://${gituser}:${github_personal_token}@github.com/${gituser}/${dotfilerepo}.git" "$dotdir"
}

# Function to symlink the dotfiles
symlink_dotfiles() {
  echo "Symlinking the dotfiles..."
  cd "$dotdir" && ./install.sh -i
}

# Function to convert HTTPS to SSH in the repository
convert_https_to_ssh() {
  echo "Converting remote URLs from HTTPS to SSH..."
  cd "$dotdir"
  git remote set-url origin "git@${GIT_PRIVATE_HOST}:${gituser}/${dotfilerepo}.git"

  # Update submodule URLs
  git submodule foreach "git remote set-url origin \$(git remote get-url origin | sed -e \"s~https://github.com/~git@${GIT_PRIVATE_HOST}:~g\")"
}

# Main entry point of the script
main() {
  if [[ $1 != "--confirm" ]]; then
    echo "This script will clone your dotfiles and install them."
    echo "Please review and confirm before running."
    echo "Re-run with --confirm to proceed."
    exit 1
  fi

  # Detect the platform
  detect_platform
  # Install tools based on platform and architecture
  if [ "$PLATFORM" = "macos" ]; then
    install_dependencies_macos
  elif [ "$PLATFORM" = "linux" ]; then
    install_dependencies_linux
  fi

  # Prompt for dynamic values or use defaults
  read -p "Git user (default: $DEFAULT_GIT_USER): " gituser
  gituser="${gituser:-$DEFAULT_GIT_USER}"

  read -p "Dotfiles repo (default: $DEFAULT_DOTFILES_REPO): " dotfilerepo
  dotfilerepo="${dotfilerepo:-$DEFAULT_DOTFILES_REPO}"

  read -p "Dotfiles directory (default: $DEFAULT_DOTFILES_DIR): " dotdir
  dotdir="${dotdir:-$DEFAULT_DOTFILES_DIR}"

  # Start the operation
  prompt_for_bitwarden_credentials
  bitwarden_login
  bitwarden_unlock
  get_github_token
  configure_git
  clone_dotfiles_repo
  symlink_dotfiles
  convert_https_to_ssh

  echo "Dotfiles have been successfully installed and converted to use SSH."
}

# Run the main function with all script arguments
main "$@"
