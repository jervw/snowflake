{ config, pkgs, ... }:

{
  home.username = "jere";
  home.homeDirectory = "/home/jere";
  home.stateVersion = "22.11"; 

  imports = [ ../modules/programs/helix ];

  home.packages = [
    pkgs.rust-analyzer
  ];

  home.file = {};

  home.sessionVariables = {};

  programs.home-manager.enable = true;
}
