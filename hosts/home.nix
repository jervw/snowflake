# Universal packages shared between all hosts
{ config, lib, pkgs, user, ...}:

{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      firefox
      neovim
      neofetch
      ripgrep
      discord
      kitty
      alacritty
      cider
      rustup
    ];

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
