{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    #Hardware
    lm_sensors
    bluez
    mesa
    qemu
    quickemu
    wireshark

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

    # hyprland plugins
    hyprlandPlugins.hyprbars
    inputs.hyprview.packages."${pkgs.system}".hyprview
  ];
}
