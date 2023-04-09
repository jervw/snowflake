# Universal packages shared between all hosts
{ config, lib, pkgs, user, ... }:

{
  # Modules
  imports = 
    (import ../modules/programs) ++
    (import ../modules/services);

  # Home manager configuration
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Development
      cmake
      gcc
      clang
      llvm
      python3
      rustup

      # Applications
      firefox
      librewolf
      discord-canary
      cider

      # Utilities
      bat
      exa
      pfetch
      ripgrep
      fd
    ];

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
