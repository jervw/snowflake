{ config, nixpkgs, ... }:

{
  home.username = "jere";
  home.homeDirectory = "/home/jere";
  home.stateVersion = "22.11"; 

  imports = [ 
    ../modules/programs/helix
    ../modules/programs/fish
    ../modules/programs/tmux
  ];

  home.packages = with pkgs; [
    rust-analyzer
    bat
    fd
    exa
  ];

  home.sessionVariables = {};

  programs.home-manager.enable = true;
}
