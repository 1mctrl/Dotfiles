{ config, pkgs, nixGL, system, ... }:

let
  blenderWrapped = pkgs.writeShellScriptBin "blender" ''
    exec ${nixGL.packages.${system}.nixGLIntel}/bin/nixGLIntel ${pkgs.blender}/bin/blender "$@"
  '';

in
{
  home.username = "icon";
  home.homeDirectory = "/home/icon";

  home.stateVersion = "25.11";

  home.packages = [
    pkgs.android-studio
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
    pkgs.julia-bin
    pkgs.vlc
    pkgs.tor-browser
    pkgs.brightnessctl
    pkgs.qemu_full
    pkgs.grim
    pkgs.xfce.thunar
    pkgs.ayugram-desktop
    pkgs.btop
    pkgs.htop
    pkgs.libreoffice
    pkgs.mc
    pkgs.gusb
    pkgs.starship
    pkgs.librewolf
    pkgs.emacs
    pkgs.xprintidle
    pkgs.xkeyboard-config
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
