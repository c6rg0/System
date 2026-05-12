{ config, pkgs, my-modules, ... }:

{
  home.enableNixpkgsReleaseCheck = false; 
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.username = "gabriel";
  home.homeDirectory = "/home/gabriel";
  xdg.enable = true;

  imports = [
    ./modules/home-manager/sway.nix
      ./modules/home-manager/waybar.nix
      ./modules/home-manager/kitty/kitty.nix
      ./modules/home-manager/nvim/nvim.nix
      ./modules/home-manager/fastfetch/fastfetch.nix
      ./modules/home-manager/rofi.nix
      ./modules/home-manager/gtk.nix
      ./modules/home-manager/ghostty.nix
  ];

  home.packages = with pkgs;[

# Dev tools
    git
      yazi
      tmux
      zsh-powerlevel10k
      zsh-you-should-use
      nixpkgs-review
      gh
      python315
      nodejs_24
      typescript
      sqlitebrowser
      ghidra
      vscode-fhs
      uv

# Utils
      binutils
      findutils
      wl-clipboard-rs
      killall
      ntfs3g
      file
      wev
      _7zz
      yt-dlp
      gammastep
      pass
      gnupg

# School/Learning
      teams-for-linux 
      anki

# General software
      qimgv
      libreoffice
      pastel
      spotify
      gimp
      darktable
      neomutt
      krita 
      onefetch
      hyprpicker
      hyprshot
      zathura
      qutebrowser
      obs-studio

# Gaming 
      osu-lazer-bin
      protonup-qt
      wine
      etterna

# Dependencies for screensharing (iirc) 
      slurp
      zenity

    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  services.dunst.enable = true;  # Notifications

# For OBS/Screensharing (only tried the OBS part lol)
    xdg = {
      portal = {
        enable = true;

        config = {
          sway = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];
      };
    };

}

