{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
      #Hardware
    lm_sensors
    bluez
    mesa
    qemu
    quickemu

      # Root
    wtype
    pavucontrol
    ldacbt
    blueman

      # Troubleshooting
    vim
    busybox
    unzip
    flatpak
    man-pages
    man-pages-posix
    std-man-pages
    linux-manual
  ];
}

