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
      llvm
      python3
      rustup
      clang-tools
      nodejs
      nodePackages.pnpm

      # Applications
      firefox
      discord-canary
      qbittorrent
      cider
      mpv
      feh

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
