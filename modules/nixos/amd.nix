{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  hardware.amdgpu = {
    initrd.enable = true; 
  };
  
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-validation-layers
      amkdvlk
    ];
  };

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    WLR_RENDERER = "vulkan";
    NIXOS_OZONE_WL = "1";
  };
}
