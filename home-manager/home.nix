{ config, pkgs, my-modules, ... }:

{
  home.enableNixpkgsReleaseCheck = false; 
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "gabriel";
  home.homeDirectory = "/home/gabriel";
  xdg.enable = true;

  imports = [
    "${my-modules}/sway/sway.nix"
    "${my-modules}/waybar.nix"
    "${my-modules}/kitty/kitty.nix"
    "${my-modules}/nvim/nvim.nix"
    "${my-modules}/fastfetch/fastfetch.nix"
    "${my-modules}/rofi.nix"
    "${my-modules}/gtk.nix"
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
      ventoy
      ntfs3g
      file
    
      qimgv
      libreoffice
      pastel
      teams-for-linux
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
    ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  services.dunst.enable = true;  # Notifications

}

