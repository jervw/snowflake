# Specific packages for Desktop
{ pkgs, hyprland, ... }:

{
  imports = [
    ../../modules/desktop/hyprland/config.nix
    ../../modules/programs
    ../../modules/services
  ];

  home = {
    packages = with pkgs; [
      calibre
      xfce.thunar
      feh
      lxappearance
      morgen
      lazygit
      playerctl
      pavucontrol
      viewnior
      orchis-theme
      steam
      spotify
      webcord-vencord
      prismlauncher
      jdk17
      networkmanagerapplet
      obs-studio
    ];
  };
}
