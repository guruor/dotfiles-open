#!/bin/bash

# Get the virtual environments path from the environment variable
VENV_PATH=${PYTHON_VENV_PATH:-"$HOME/.virtualenvs"}

# Create virtual environment function
create_venv() {
  local VENV_DIR=$1
  local PACKAGES=$2

  if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install $PACKAGES
    deactivate
  else
    echo "Virtual environment at $VENV_DIR already exists."
  fi
}

# Ensure the base directory exists
mkdir -p "$VENV_PATH"

# Create virtual environments
create_venv "$VENV_PATH/nvim" "pynvim neovim"
create_venv "$VENV_PATH/debugpy" "debugpy"
