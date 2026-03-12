{ config, pkgs, lib, ... }:

{
  programs.ghostty = lib.mkForce {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = "Gruvbox Dark Hard";
      font-size = 17;
      cursor-style = "block";
      cursor-style-blink = false;
    };
  };
}
