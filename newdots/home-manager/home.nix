{ config, pkgs, ... }:

{

  home.username = "icon";
  home.homeDirectory = "/home/icon";

  home.stateVersion = "25.11"; 
  

  home.packages = [

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
  pkgs.eww
  
  ];


  home.sessionVariables = {
     EDITOR = "emacs";
  };

  programs.starship = {
                    enable = true;
  };
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}
