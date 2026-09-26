{ config, pkgs, ... }:

{
  xdg.configFile = {
    "hypr/".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/System/dotfiles/hypr/";
  };
}
