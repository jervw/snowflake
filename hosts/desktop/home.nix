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
      firefox-wayland
      calibre
      xfce.thunar
      mpv
      feh
      lxappearance
      morgen
      lazygit
      playerctl
      pavucontrol
      orchis-theme
      steam
      spotify
      discord-canary
      networkmanagerapplet
      obs-studio
    ];
  };
}
