{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
    
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  
  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

}
