{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
      user = "gabriel";
    };
  };
 
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    wev
    brightnessctl
    playerctl
    wlroots_0_19
    firefox
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.symbols-only
    noto-fonts-cjk-sans
  ];

  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      exec systemctl --user set-environment XDG_CURRENT_DESKTOP=sway

      exec systemctl --user import-environment DISPLAY \
        SWAYSOCK \
        WAYLAND_DISPLAY \
        XDG_CURRENT_DESKTOP

      exec hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
          SWAYSOCK \
          XDG_CURRENT_DESKTOP=sway \
          WAYLAND_DISPLAY
          '';
  };

}
