{ config, pkgs, ... }:

{
  nixpkgs.config.pulseaudio = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
