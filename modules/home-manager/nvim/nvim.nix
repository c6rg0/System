{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;

    initLua = ''
      ${builtins.readFile ./init.lua}

    '';
  };

  home.packages = with pkgs; [
    lua-language-server
      pyright
      typescript-language-server
  ];

}

