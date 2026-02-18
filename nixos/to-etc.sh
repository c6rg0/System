#/usr/bin/env bash

sudo cp -v ./*.nix /etc/nixos/
sudo cp -v ./flake.lock /etc/nixos/
echo "Please generate your own hardware-configuration if needed"

