{ config, pkgs, lib, ... }:

{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      background_opacity = 1;
      background_blur = 3;
      term = "xterm-kitty";
      enable_audio_bell = "no";
      linux_display_server = "wayland";

      font_size = "17.5";
      font_family = "AurulentSansM Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      include = "/home/gabriel/.config/modules/kitty/current-theme.conf";

      cursor_shape = "block";
      cursor_blind_interval = 0;
      cursor_stop_blinking_after = 0;
      shell_integration = "no-cursor";

      scrollpack_lines = 10000;
      wheel_scroll_multiplier = "3.0";
      mouse_hide_wait = "-1";

      remember_window_size = "no";
      initial_window_width =  1200;
      initial_window_height = 750;
      window_border_width = "0pt";
      enabled_layouts = "tall";
      window_padding_width = 0;
      window_margin_width = 2;
      hide_window_decorations = "no";

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "bottom";
      tab_bar_align = "left";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";






    };
  };
}
