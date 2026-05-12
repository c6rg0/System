{ config, lib, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        source = ./nix.txt;
        height = 10;
        padding = {
          top = 2;
        };
      };

      display = {
        separator = "  ";
        constants = [
          "─────────────────"
        ];
        key = {
          type = "icon";
          paddingLeft = 2;
        };
      };

      modules = [{
        type = "custom";
        format = "┌{$1} {#1}Hardware Information{#} {$1}┐";
      }
        "host"
        "cpu"
        "gpu"
        "disk"
        "memory"
        { 
          type = "custom";
          format = "├{$1} {#1}Software Information{#} {$1}┤";
        }{
          type = "title";
          keyIcon = "";
          key = "Title";
          format = "{user-name}@{host-name}";
        }
        "kernel"
          "de"
          "wm"
          "terminalfont"
          "icons"
          "wallpaper"
          "packages"
          "uptime"
          { 
            type = "localip";
            compact = true;
          }
        /* {
           type = "publicip";
           timeout = 1000;
           } */
        { 
          type = "custom";
          format = "└{$1}──────────────────────{$1}┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "square";
        }
      ];
    };
  };
}
