{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false;
  };
  
  hardware.graphics.enable = true;

  environment.variables = {
    LIBVA_DRIVER_NAME="nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };
}
