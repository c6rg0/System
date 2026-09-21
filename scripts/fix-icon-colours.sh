#!/usr/bin/env bash
# Changes icon colours from gray to white-ish

cd ./dotfiles/quickshell/share/icons/
sed -i "s/363636/E0E0E0/g" $(find . -type f -path "*.svg")
