#!/usr/bin/env bash
# Testing a post-install script

# Track the results of the install script
exec &> "$HOME/post-install.log"

echo "Post-install script executed" 