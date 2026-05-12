{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";

    extraConfig = {
      modi = "window,drun,run";
      font = "IosevkaTerm Nerd Font Propo 19";
      show-icons = true;
      terminal = "kitty";
    };
  };
}
