{ pkgs, config, ... }:

{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    qt6Packages.qt5compat
  ];

  xdg.configFile = {
    "quickshell".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/System/dotfiles/quickshell";
  };
}
