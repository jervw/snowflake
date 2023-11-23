# Specific packages for Desktop
{ pkgs, user, ... }:

{
  imports = [
    ../../home/core
  ];

  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      # Packages
    ];

    stateVersion = "23.05";
  };
}
