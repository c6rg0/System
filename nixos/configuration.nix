{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix 
    ./nvidia.nix
    ./display.nix
    ./zsh.nix
    ./time_and_keys.nix
    ./networking.nix
    ./audio.nix
    ./tablet.nix
    ./flatpaks.nix
    ];

  system.stateVersion = "25.05"; # Read the docs before touching!
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 0; # This does nothing, in the boot menu, use "shift + t" to disable the boot menu
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  /*
  boot.kernelModules = [ 
    "kvm-intel" 
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];
  */

  boot.kernelParams = [ 
    "nvidia-drm.modeset=1"
    /*
    "intel_iommu=on"
    "vfio-pci.ids=1e0f:0001,10de:1f99"
    */
  ];

  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ];

  networking.hostName = "dell";
  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Rules:
    # Only install things here that require root;
    # Are hardware related;
    # Or are needed if you can't access the user.

    #Hardware
    lm_sensors
    bluez
    mesa

    # Root
    home-manager
    
    # Troubleshooting
    vim
    busybox
    unzip

    flatpak
    
    dnsmasq # For virtualisation
    wtype 
  ];

  programs.steam = {
    enable = true;
  };

  services.flatpak.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  

}
