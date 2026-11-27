{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "SF Pro:size=17";
        icon-theme = "WhiteSur-dark";
      };
      colors = {
        # Colour format: "{hex}ff".
        # I'm using colours from:
        # dotfiles/kitty/gruvbox-light.conf.

        background = "fbf1c7ff";
        text = "3c3836ff";
        # message = "";
        prompt = "3c3836ff";
        # placeholder = "";
        input = "3c3836ff";
        match = "7c6f64";
        selection-text = "3c3836ff";
        selection-match = "d79921";
        # counter = "458588ff";
        border = "002b36ff"; # default
      };
    };
  };
}
