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

    # Fixes common GTK 3 issues
    wrapperFeatures.gtk = true; 

    config = rec {
      defaultWorkspace = "workspace number 1";
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

      modifier = "Mod4"; 
        # modifier = meta key = "windows" key
      terminal = "kitty"; 
      menu = "rofi -show drun";

      keybindings = {
        # Program launches
        "${modifier}+q" = "exec ${terminal}";
        "${modifier}+Space" = "exec ${menu}";
        "${modifier}+b" = "exec firefox";
        "${modifier}+Shift+l" = "exec swaylock -c 282828";
          # "-c ..." specifies lock background colour
        "${modifier}+w" = "exec waybar";

        # Keybinds to disable/enable laptop screen (for external monitor)
        "${modifier}+d" = "exec ld0";
        "${modifier}+Shift+d" = "exec ld1";

        # Symbols used for programming
        "${modifier}+o" = "exec wtype '|'";
        "${modifier}+Shift+Escape" = "exec wtype '`'";
          # '\' = RightAlt + Minus

        "${modifier}+Shift+r" = "reload"; 
        "${modifier}+k" = "kill";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Escape" = "floating toggle";
          #"${modifier}+Return" = "focus parent"; # No clue what this is

        # Scratchpad allows hiding programs
        "${modifier}+Minus" = "move scratchpad";
        "${modifier}+Equal" = "scratchpad show";

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

        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

        # Audio
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2.5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2.5%";
        "${modifier}+Shift+Equal" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2.5%";
        "${modifier}+Shift+Minus" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2.5%";

        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "${modifier}+m" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

        "XF86AudioPrev" = "exec playerctl previous";
        "${modifier}+numbersign" = "exec playerctl previous";

        "XF86AudioPlay" = "exec playerctl play-pause";
        "${modifier}+Return" = "exec playerctl play-pause";

        "XF86AudioNext" = "exec playerctl next";
        "${modifier}+Shift_R" = "exec playerctl next";

        # Workspace management 
        "${modifier}+Tab" = "workspace next";
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
      };
    };
  };
}
