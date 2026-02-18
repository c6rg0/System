#!/usr/bin/env bash

rm -fv /home/gabriel/.config/nixos/*.nix
sudo cp -v /etc/nixos/*.nix /home/gabriel/.config/nixos/
sudo cp -v /etc/nixos/flake.lock /home/gabriel/.config/nixos/flake.lock
echo "Please generate your own hardware-configuration if needed"
rm -fv /home/gabriel/.config/nixos/hardware-configuration.nix
