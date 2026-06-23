{ ... }:
let
  configs = builtins.path {
    path = ./.;
    name = "quickshell-configs";
  };
in
{
  programs.quickshell = {
    enable = true;
    activeConfig = configs;
    systemd.enable = true;
  };
}
