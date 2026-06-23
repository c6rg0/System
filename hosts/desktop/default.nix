{ inputs, outputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/pkgs.nix
    ../../nixos/amd.nix
    ../../nixos/audio.nix
    ../../nixos/display.nix
    ../../nixos/networking.nix
    ../../nixos/tablet/module.nix
    ../../nixos/tablet.nix
    ../../nixos/locale.nix
    ../../nixos/shell.nix
  ];

  networking.hostName = "pc";
  system.stateVersion = "25.11"; # keep whatever yours currently is

  services.displayManager.ly.enable
}
