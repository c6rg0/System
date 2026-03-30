{ inputs, outputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/display.nix
    ../../modules/nixos/flatpaks.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/tablet.nix
    ../../modules/nixos/time_and_keys.nix
    ../../modules/nixos/zsh.nix

  ];

  networking.hostName = "dell";
  system.stateVersion = "25.11"; # keep whatever yours currently is
}
