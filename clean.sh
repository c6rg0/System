#!/usr/bin/env bash

# (iirc) Removes any unused /nix/store/* packages

sudo nix-collect-garbage -d 
