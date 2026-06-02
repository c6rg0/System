{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = true;
  };

  home.packages = with pkgs; [
    lua-language-server
      pyright
      typescript-language-server
  ];

  xdg.configFile."nvim/init.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "/home/gabriel/Config/modules/home-manager/nvim/init.lua";
  };
}
