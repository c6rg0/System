# My NixOS config:
- *Hyprland/quickshell configs are forked from [luyu-wu/Config](https://github.com/luyu-wu/Config).*

## *Outdated showcase*:
![desktop](pictures/desktop.png)

![neovim](pictures/neovim.png)


|               |               |
| ------------- |:-------------:|
| operating system | nixos linux |
| dotfile management | home-manager |
| display manager | tuigreet (greetd) |
| window manager | hyprland (wayland) |
| desktop shell | quickshell |
| colour scheme | gruvbox |
| gtk/icon/cursor theme | WhiteSur/MacTahoe |
| terminal emulator | kitty |
| shell | zsh |
| wallpaper utility | awww |



## IMPORTANT!
- Make sure that you have flakes enabled on your machine.

- Don't use the `hardware-configuration.nix`s included in this repo,
  they're not generated for your hardware. Instead, use your own version 
  created during installation or make a new copy (`$ nixos-generate-config`).

- Read any scripts before use; they're all short, and it's good practice.

- The scripts include commands for: updating/installing the config and 
  removing redundanct versions of packages.


## Location
- The repo works if it's located at `/home/$(whoami)/System/` (since I have some hardcoded paths).


## Extra
- To disable the boot menu, use `shift+t ` in the menu until the timeout is 0.
  and install the config using the flake. 

