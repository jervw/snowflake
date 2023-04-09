# Specific packages for Desktop
{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      networkmanagerapplet
      steam
    ];
  };
}
