# My NixOS config:
*NOTE: I have random things in my home.nix like "osu-lazer-bin", delete them*
*as you please, I'll try make it obvious whether a package is important or not.*
*Also - shell.nix is an example I set up for an extremely simple python project, 
*it's not essential, just a template I/you can use.*

> Colour scheme = Gruvbox light

> Dotfile management = Home-manager\
> Display manager = tuigreet (terminal based)\
> Shell = zsh (with p10k theme and other QOL settings)
> Window manager = Sway (wayland)\
> Bar = Waybar\
> Terminal = Kitty\
> Text editor = Neovim\
> App launcher = Rofi\
> Info-fetcher = Fastfetch 

- My config also has a successful nvidia setup for the 
  1650.
- I'm using a flake.nix as a replacement for nix-channel.


## Showcase
![desktop](Showcase_images/desktop.png)

![rofi](Showcase_images/rofi.png)

![fastfetch](Showcase_images/fastfetch.png)

![neovim](Showcase_images/neovim.png)


## File structure
* `nixos/` files go in `/etc/nixos/`,
* `home-manager/` and `modules/` sit in `~/.config`,

- To make Systemd-boot go straight to nixos, edit `/boot/loader/loader.conf`,
  and edit the TIMEOUT to 0. 
- If you execute install.sh (`./install.sh`), it'll move all the files to their place, 
  load the configs and install the packages. 
    - Please back up your previous config before running it, and don't execute random 
      scripts from the internet (the script is less than 20 lines long, read it first!). 

- Also, please generate your own hardware-configuration.nix, and that you have enabled 
  flakes functionality before using this config.
- If you have a different user name (that isn't "gabriel"), this config won't work unless
  you swap out the "gabriel"s in the configuration.nix for your own.


## Credits:
Waybar config = [mxkrsv/dotfiles-old](https://github.com/mxkrsv/dotfiles-old/tree/master/.config/waybar)
*(I ported the config to nix, and changed the colour scheme and order)*

Colour scheme = [hmorhetz/gruvbox](https://github.com/morhetz/gruvbox)


