{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";

    extraConfig = {
      modi = "window,drun,run,ssh";
      font = "AurulentSansM Nerd Font Mono 15";
      show-icons = true;
      terminal = "kitty";
    };
  };

}
