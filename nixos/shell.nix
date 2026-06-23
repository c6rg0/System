{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git" "z"];
    };

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    # Theme
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

    shellInit = ''
      export SYSTEMD_PAGER=cat
      export PAGER=cat
      export MANPAGER='nvim +Man!'
      export PATH=/home/gabriel/.local/bin:$PATH
    '';
    
    shellAliases = {
      bt = "bluetoothctl";
      gs = "git status";
      ld0 = "swaymsg output eDP-1 disable";
      ld1 = "swaymsg output eDP-1 enable";
      py = "python";
      night = "gammastep -O 4500K";
      day = "exec gammastep -O 6500K";

      up = "CURRENT=$(pwd) && cd $CONFIG_lOCATION && sudo nix flake update && sudo nixos-rebuild switch --flake .#laptop && cd $CURRENT";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };
}
