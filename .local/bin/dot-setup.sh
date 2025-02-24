#!/bin/bash

# Exit on error
set -e

# Constants
DEFAULT_GIT_USER="guruor"
DEFAULT_DOTFILES_REPO="dotfiles-open"
DEFAULT_DOTFILES_DIR="$HOME/voidrice"
GIT_PRIVATE_HOST="github-personal"
BW_GITHUB_ITEM_NAME="Github Govind Personal"
BW_GITHUB_ITEM_NOTES_YAML_KEY=".tokens.personal_access_token"

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
  github_personal_token=$(bw get item "${BW_GITHUB_ITEM_NAME}" | yq ".notes | fromjson | ${BW_GITHUB_ITEM_NOTES_YAML_KEY}")
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
