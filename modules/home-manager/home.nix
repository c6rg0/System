{ config, pkgs, my-modules, ... }:

{
  home.enableNixpkgsReleaseCheck = false; 
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.username = "gabriel";
  home.homeDirectory = "/home/gabriel";
  xdg.enable = true;

  imports = [
    ./pkgs.nix
    ./sway.nix
    ./waybar.nix
    ./kitty/kitty.nix
    ./nvim/nvim.nix
    ./rofi.nix
    ./gtk.nix
    ./fastfetch/fastfetch.nix
    # ./ghostty.nix # I don't use this at all
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

