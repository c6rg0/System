{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  cmake,
  wayland,
  libGL,
  pkg-config,
  gettext,
  gtk3,
  glib,
  cairo,
  librsvg,
  dbus,
  dbus-glib,
  libxml2,
  libGLU,
  curl,
  gtk-layer-shell,
}:

stdenv.mkDerivation rec {
  pname = "cairo-dock-core";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "Cairo-Dock";
    repo = "cairo-dock-core";
    rev = "${version}";
    sha256 = "sha256-csdqDyKLw3olwmDKwUOB37dJxGFcxhOLQoDHuHBsCbE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    glib
    gtk-layer-shell.dev
    pkgs.kdePackages.extra-cmake-modules
    wayland.dev
  ];

  buildInputs = [
    libGL
    libGLU
    gtk3
    glib.dev
    cairo
    librsvg
    dbus
    dbus-glib
    libxml2
    wayland
    curl
  ];
  
  preConfigure = ''
    echo "=== PKG_CONFIG_PATH ===" 
    echo $PKG_CONFIG_PATH
    echo "=== gio-unix-2.0 ==="
    pkg-config --cflags gio-unix-2.0 || echo "NOT FOUND"
    echo "=== glib.dev include ==="
    find ${glib.dev} -name "gdesktopappinfo.h" || echo "NOT FOUND IN GLIB.DEV"
  '';

  NIX_CFLAGS_COMPILE = toString [
    "-I${glib.dev}/include/gio-unix-2.0"
    "-I${glib.dev}/include/glib-2.0"
    "-I${glib.dev}/lib/glib-2.0/include"
    "-I${glib.dev}/include" # gio/ lives directly under here
  ];

  meta = with lib; {
    homepage = "https://github.com/Cairo-Dock/cairo-dock-core";
    description = "A pretty, light and convenient interface to your desktop.";
    license = lib.licenses.gpl3Only;
    mainProgram = "cairo-dock";
    maintainers = with lib.maintainers; [ c6rg0 ];
    platforms = lib.platforms.linux;
  };
}
