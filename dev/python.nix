let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable") {};
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      tkinter 
    ]))
  ];
}
