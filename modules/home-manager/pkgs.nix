{ pkgs, ... }:

{
  home.packages = with pkgs;[
# Shell utils
    zsh-powerlevel10k
    zsh-you-should-use
    binutils
    findutils
    killall
    ntfs3g
    file
    wev
    _7zz
    yt-dlp
    ffmpeg
    pass
    gnupg
    exiftool
    zip

# Dev tools
    git
    nixpkgs-review
    gh
    sqlitebrowser
    ghidra
    vscode-fhs
    onefetch
    uv
    ruff
    iaito
    ghidra
    clang-tools

# Languages
    python315
    nodejs_24
    typescript

# Miscellaneous utils
    awww
    wl-clipboard-rs
    gammastep
    alsa-lib

# School/Learning
    teams-for-linux 
    anki

# General software
    qimgv
    libreoffice
    pastel
    spotify
    gimp
    darktable
    neomutt
    krita 
    hyprpicker
    hyprshot
    zathura
    obs-studio
    vlc

# Gaming
    osu-lazer-bin
    protonup-qt
    wine
    etterna

# Dependencies for screensharing (AFAIK) 
    # slurp
    # zenity
  ];
}
