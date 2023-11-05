# Universal packages shared between all hosts
{ pkgs, user, ... }:

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
      eza
      pfetch
      ripgrep
      fd
      fzf
    ];

    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };
}
