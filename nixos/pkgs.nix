{ config, pkgs, ... }:

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
    alsa-utils

      # Troubleshooting
    vim
    busybox
    unzip
    flatpak
    man-pages
    man-pages-posix
    stdmanpages
    linux-manual
  ];
}

