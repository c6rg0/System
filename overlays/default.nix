let
  pkgs = import <nixpkgs> {};
in
  pkgs.callPackage ./cairo-dock.nix {}
