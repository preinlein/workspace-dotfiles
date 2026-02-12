#!/usr/bin/env bash
# Testing a post-install script

# Track the results of the install script
exec &> "$HOME/post-install.log"

echo "Post install script executing..."

# Clone main working repositories
echo "Cloning main working repositories..."
cd dd
git clone https://github.com/DataDog/lading.git
git clone https://github.com/DataDog/single-machine-performance.git
cd -