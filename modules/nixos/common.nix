{ config, pkgs, lib, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 0; # This does nothing, in the boot menu, use "shift + t" to disable the boot menu
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.dbus.implementation = "broker";

  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ];

  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [

    # Rules:
    # Only install things here that require root,
    # or you want to persist if you can't access user. 
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
    linux-manual
  ];

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
  };
  
  documentation.enable = true;
  documentation.man = {
    enable = true;
    cache.enable = false;
  };
  documentation.dev.enable = true;

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  environment.variables = {
    # To fix a problem with anki
    QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu";
  };

}
