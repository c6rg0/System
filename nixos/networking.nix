{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openssh
  ];
  
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = false;
  
  networking.firewall.enable = true;

  # "virbr0" = virtual bridge (for virtualization)
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Instrusion prevention software
  services.fail2ban.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.pcscd.enable = true;
}
