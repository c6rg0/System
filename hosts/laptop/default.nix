{ inputs, outputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/pkgs.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/display.nix
    ../../modules/nixos/flatpaks.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/tablet/module.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/shell.nix
  ];

  networking.hostName = "dell";
  system.stateVersion = "25.11"; # keep whatever yours currently is

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
      user = "gabriel";
    };
  };
}
