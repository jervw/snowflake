# Universal packages shared between all hosts
{ config, hyprland, lib, pkgs, user, ... }:

{
  # Home manager configuration
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Development
      cmake
      gcc
      llvm
      python3
      rustup
      clang-tools
      nodejs
      nodePackages.pnpm

      # Utilities
      bat
      xdg-utils
      exa
      pfetch
      ripgrep
      fd
      fzf
    ];

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
