{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    glfw
    libGL
    pkg-config
  ];

  shellHook = ''
    echo "C development environment loaded"
    echo "Compiler: $(gcc --version | head -n1)"
  '';
}

