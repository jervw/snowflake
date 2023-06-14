# Specific packages for Desktop
{ pkgs, hyprland, ... }:

{
  imports = [ ../../modules/desktop/hyprland/config.nix ];

  home = {
    packages = with pkgs; [
      networkmanagerapplet
      lutris
      obs-studio
    ];
  };

}
