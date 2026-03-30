{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    swaylock
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      color = "282828";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      show-failed-attempts = true;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true; # Fixes common GTK 3 issues
      config = rec {
        defaultWorkspace = "workspace number 1";

        modifier = "Mod4"; # The windows/meta key
          terminal = "kitty"; 
        menu = "rofi -show drun";

        window.border = 0;
        window.titlebar = false;

        output = {
          "eDP-1" = {
            pos = "0 0";
            res = "1920x1080";
          };
          "HDMI-A-3" = {
            pos = "0 0";
            res = "1920x1080";
          };
          "*" = {
            bg = "/home/gabriel/Pictures/wallpaper fill";
          };
        };

        input = {
          "type:touchpad" = {
            natural_scroll = "enabled";
          };
          "type:pointer" = {
            natural_scroll = "disabled";
          };
          "type:keyboard" = {
            xkb_layout = "gb";
          };
        };

        bars = [];

        keybindings = {
          "${modifier}+q" = "exec ${terminal}";
          "${modifier}+Space" = "exec ${menu}";
          "${modifier}+b" = "exec firefox";
          "${modifier}+w" = "exec waybar";
          "${modifier}+Shift+l" = "exec swaylock -c 282828";

          # Symbols used for programming
          "${modifier}+o" = "exec exec wtype '|'";
          "${modifier}+s" = "exec exec wtype '\\'";
          "${modifier}+Shift+Escape" = "exec exec wtype '`'";

          "${modifier}+k" = "kill";
          "${modifier}+f" = "fullscreen";
          "${modifier}+Escape" = "floating toggle";
          #"${modifier}+Return" = "focus parent"; # No clue what this is

          "${modifier}+Minus" = "move scratchpad";
          "${modifier}+Equal" = "scratchpad show";

          "${modifier}+Shift+r" = "reload";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Pane management (horizontal/vertical)
          "${modifier}+h" = "splitv";
          "${modifier}+v" = "splith";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2.5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2.5%";

          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

          "XF86AudioPrev" = "exec playerctl previous";
          "${modifier}+numbersign" = "exec playerctl previous";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "${modifier}+Return" = "exec playerctl play-pause";

          "XF86AudioNext" = "exec playerctl next";
          "${modifier}+Shift_R" = "exec playerctl next";
        };
      };
  };
}
