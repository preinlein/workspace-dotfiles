#!/usr/bin/env bash

# Once the workspace is created, this script will execute. 
# This will happen in place of the default behavior of the workspace system,
# which is to symlink the dotfiles copied from this repo to the home directory in the workspace.

set -euo pipefail

# Track the results of the install script
exec &> "$HOME/install.log"

# Attempting to do a post-install script
# ~/dotfiles is the path where this repo is cloned to within the workspace
nohup ~/dotfiles/post-install.sh > ~/post-install.log 2>&1 &
disown

# Symlink dotfiles to the root within the workspace
echo "Symlinking dotfiles to the root within the workspace..."
DOTFILES_PATH="$HOME/dotfiles"

find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

# Update Claude Code
echo "Updating Claude Code..."
if command -v volta &>/dev/null; then
    volta install @anthropic-ai/claude-code@latest
    echo "claude version: $(claude --version 2>&1)"
else
    echo "volta not found, falling back to claude update"
    claude update || true
fi

# Configure Rust tooling
echo "Configuring Rust tooling..."
if command -v rustup &>/dev/null; then
    echo "Rust already installed: $(rustc --version)"
    rustup update stable
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo "Rust installed: $(rustc --version)"
fi

# Configure protoc
echo "Installing protoc..."
if command -v protoc &>/dev/null; then
    echo "protoc already installed: $(protoc --version)"
else
    sudo apt-get update -qq && sudo apt-get install -y -qq protobuf-compiler
fi

# Clone main working repositories
echo "Cloning main working repositories..."
cd dd
git clone https://github.com/DataDog/lading.git
git clone https://github.com/DataDog/single-machine-performance.git
cd -