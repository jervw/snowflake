# Universal packages shared between all hosts
{ config, lib, pkgs, user, ... }:

{
  # Modules
  imports = 
    (import ../modules/programs) ++
    (import ../modules/services);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      firefox
      vim
      neofetch
      ripgrep
      discord
      kitty
      cider
      rustup
    ];

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
