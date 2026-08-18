{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    theme = ./theme.rasi;

    extraConfig = {
      modi = "window,drun,run";
      font = "IosevkaTerm Nerd Font Propo 19";
      show-icons = true;
      terminal = "kitty";
    };
  };
}
