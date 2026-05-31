{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    
    # If this does nothing,
    # use "shift + t" in the boot menu
    timeout = 0; 
  };
  boot.tmp.cleanOnBoot = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
    };
  };

  services.dbus.implementation = "broker";

  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ];

  # Change "gabriel" if your user is different 
  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  environment.variables = {
    # To fix a problem with anki
    QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu";

    # Change this below if different
    CONFIG_lOCATION = "/home/gabriel/Config/";
  };

  documentation.enable = true;
  documentation.dev.enable = true;
  documentation.man = {
    enable = true;
    cache.enable = false;
  };

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;

    # package = pkgs.steam.override {  
      # extraBwrapArgs = [  
        # "--bind $HOME/steamhome $HOME"  
        # "--bind $HOME/Games/Steam $HOME/.local/share/Steam"  
      # ];  
    # };
  };
  
  programs.nix-ld.enable = true;
  # virtualisation.docker.enable = true;
}
