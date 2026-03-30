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

  # Packages that should be installed to the user profile.
    home.packages = with pkgs;[
      git
      yazi
      tmux

      zsh-powerlevel10k
      zsh-you-should-use

      nixpkgs-review
      gh
      binutils
      python315
      nodejs_24
      typescript
      sqlitebrowser
      
      wl-clipboard-rs
      killall
      ntfs3g
      file
    
      qimgv
      libreoffice
      pastel
      teams-for-linux # build failure with electron
      spotify
      gimp
      neomutt
      
      osu-lazer-bin
      protonup-qt
      wine
      krita 

      onefetch
      btop
      hyprpicker
      hyprshot
      wev
      _7zz
      yt-dlp
      zathura
      qutebrowser
      gammastep
      obs-studio
      slurp
      zenity
      anki
      ghidra
      vscode-fhs
    ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  services.dunst.enable = true;  # Notifications

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

