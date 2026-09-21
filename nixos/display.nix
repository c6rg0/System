{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet";
      user = "gabriel";
    };
  };

  environment.systemPackages = with pkgs; [
    wev
    brightnessctl
    playerctl
    firefox
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    noto-fonts-cjk-sans
    inputs.apple-fonts.packages."${pkgs.system}".sf-pro
  ];

  programs.sway = {
    enable = false;
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

  programs.hyprland = {
    enable = true;
  };

  environment.sessionVariables = {
    QML_IMPORT_PATH = "${pkgs.qt6Packages.qt5compat}/lib/qt-6/qml";

    QML2_IMPORT_PATH = "${pkgs.qt6Packages.qt5compat}/lib/qt-6/qml";
  };
}
