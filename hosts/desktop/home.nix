# Specific packages for Desktop
{ pkgs, hyprland, ... }:

{
  imports = [
    ../../modules/wayland/hyprland/config.nix
    ../../modules/programs
    ../../modules/services
  ];

  home = {
    packages = with pkgs; [
      calibre
      xfce.thunar
      mpv
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
      discord-canary
      networkmanagerapplet
      obs-studio
    ];
  };
}
