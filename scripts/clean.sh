#!/usr/bin/env bash

# Removes any stale /nix/store/* packages and files

sudo nix-collect-garbage -d 
