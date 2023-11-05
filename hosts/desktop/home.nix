# Specific packages for Desktop
{ pkgs, ... }:

{
  imports = [
    ../../modules/desktop/hyprland/config.nix
    ../../modules/programs
    ../../modules/services
    ../../modules/theme
  ];

  home = {
    packages = with pkgs; [
      xfce.thunar
      feh
      morgen
      lazygit
      playerctl
      pavucontrol
      viewnior
      steam
      vesktop
      qbittorrent
      discord
      networkmanagerapplet
      obs-studio
    ];
  };
}
