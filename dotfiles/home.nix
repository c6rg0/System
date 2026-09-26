{
  config,
  pkgs,
  my-modules,
  ...
}:

{
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.username = "gabriel";
  home.homeDirectory = "/home/gabriel";
  xdg.enable = true;

  imports = [
    ./pkgs.nix
    ./theme.nix
    # ./sway.nix
    # ./waybar/default.nix
    ./hypr/default.nix
    ./quickshell/default.nix
    ./kitty/default.nix
    ./nvim/default.nix
    # ./rofi/default.nix
    ./fastfetch/default.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "kitty";
  };

  services.dunst.enable = true; # Notifications

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

  services.awww = {
    enable = true;
  };
}
