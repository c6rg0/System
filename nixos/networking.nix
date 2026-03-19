{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openssh
  ];
  
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = false;
  
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Instrusion prevention software
  services.fail2ban.enable = true;
  
}
