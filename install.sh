#!/usr/bin/env bash
# ensure you set the executable bit on the file with `chmod u+x install.sh`

# Once the workspace is created, this script will execute. 
# This will happen in place of the default behavior of the workspace system,
# which is to symlink the dotfiles copied from this repo to the home directory in the workspace.

set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

# Symlink dotfiles to the root within the workspace
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

git clone https://github.com/DataDog/lading.git dd
git clone https://github.com/DataDog/single-machine-performance.git dd
