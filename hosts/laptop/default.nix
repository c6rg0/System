{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/pkgs.nix
    ../../nixos/audio.nix
    ../../nixos/display.nix
    ../../nixos/networking.nix
    ../../nixos/nvidia.nix
    ../../nixos/tablet/module.nix
    ../../nixos/locale.nix
    ../../nixos/shell.nix
  ];

  networking.hostName = "dell";
  system.stateVersion = "25.11"; # keep whatever yours currently is

  services.upower.enable = true;
}
