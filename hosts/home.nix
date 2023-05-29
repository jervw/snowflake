# Universal packages shared between all hosts
{ config, hyprland, lib, pkgs, user, ... }:

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
      llvm
      python3
      rustup
      clang-tools
      nodejs
      nodePackages.pnpm

      # Applications
      firefox
      discord
      qbittorrent
      xfce.thunar
      morgen
      cider
      mpv
      feh
      lxappearance

      # Utilities
      bat
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
