{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_7_1;
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
  security.polkit.enable = true;

  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ];

  # Change "gabriel" if your user is different 
  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio"];
    shell = pkgs.zsh;
  };

  environment.variables = {
    # To fix a problem with anki
    QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu";

    # To fix a problem with ghidra
    _JAVA_AWT_WM_NONREPARENTING= 1;

    # Change this below if different
    CONFIG_lOCATION = "/home/gabriel/System/";
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
  
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd
    ];
  };
  # https://github.com/nix-community/nix-ld?tab=readme-ov-file#my-pythonnodejsrubyinterpreter-libraries-do-not-find-the-libraries-configured-by-nix-ld
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec -a "$0" ${pkgs.python3}/bin/python "$@"
    '')
  ];

  # virtualisation.docker.enable = true;
}
