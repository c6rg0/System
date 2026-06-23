#!/usr/bin/env bash

sudo nix flake update
sudo nixos-rebuild switch --flake .#laptop
# sudo nixos-rebuild switch --flake .#desktop
