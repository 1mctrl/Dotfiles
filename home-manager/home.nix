{ config, pkgs, nixGL, system, ... }:

let
  blenderWrapped = pkgs.writeShellScriptBin "blender" ''
    exec ${nixGL.packages.${system}.nixGLIntel}/bin/nixGLIntel ${pkgs.blender}/bin/blender "$@"
  '';

qutebrowserWrapped = pkgs.writeShellScriptBin "qutebrowser" ''
  export QTWEBENGINE_CHROMIUM_FLAGS="--disable-features=Vulkan $QTWEBENGINE_CHROMIUM_FLAGS"
  exec ${nixGL.packages.${system}.nixGLIntel}/bin/nixGLIntel \
    ${pkgs.qutebrowser}/bin/qutebrowser "$@"
'';
in
{
  home.username = "icon";
  home.homeDirectory = "/home/icon";

  home.stateVersion = "25.11";
  home.packages = [
    pkgs.cpufetch
    pkgs.openmw
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
    pkgs.python314
   # pkgs.arduino-ide
    pkgs.usbutils
    pkgs.f3
    pkgs.imagemagick
    #pkgs.transmission_4-qt
    qutebrowserWrapped
    #pkgs.qutebrowser
    pkgs.ncdu
    pkgs.steghide
    pkgs.poppler-utils
    pkgs.exiftool
    pkgs.tmux
    pkgs.lazygit
    pkgs.onefetch
    pkgs.prismlauncher-unwrapped
    pkgs.netcat
    pkgs.ipcalc
    blenderWrapped
    nixGL.packages.${system}.nixGLIntel
    pkgs.frr
    pkgs.bat
    pkgs.julia-bin
    pkgs.vlc
    #pkgs.tor-browser
    #pkgs.brightnessctl
    pkgs.qemu
    pkgs.grim
    #pkgs.thunar
    pkgs.ayugram-desktop
    pkgs.btop
    pkgs.htop
    pkgs.libreoffice
    pkgs.mc
    pkgs.gusb
    pkgs.starship
    #pkgs.librewolf
    #pkgs.emacs
    pkgs.xprintidle
    #pkgs.xkeyboard-config
    pkgs.cmatrix
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.starship.enable = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}
