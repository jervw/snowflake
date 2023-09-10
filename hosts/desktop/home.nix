# Specific packages for Desktop
{ pkgs, hyprland, ... }:

{
  imports = [
    ../../modules/desktop/hyprland/config.nix
    ../../modules/programs
    ../../modules/services
    ../../modules/theme
  ];

  home = {
    packages = with pkgs; [
      calibre
      xfce.thunar
      feh
      morgen
      lazygit
      playerctl
      pavucontrol
      viewnior
      steam
      webcord-vencord
      networkmanagerapplet
      obs-studio
    ];
  };
}
