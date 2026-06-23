{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = true;
  };

  home.packages = with pkgs; [
    vimPlugins.nvim-treesitter
    lua-language-server
    typescript-language-server
    pyright
		ripgrep
		fd
  ];

  xdg.configFile."nvim/init.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "/home/gabriel/System/dotfiles/nvim/init.lua";
  };
}
