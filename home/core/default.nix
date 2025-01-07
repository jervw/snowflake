{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./fish.nix
    ./direnv.nix
    ./helix.nix
    ./lazygit.nix
    ./syncthing.nix
    ./yazi.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    btop
    cloneit
    ncdu
    ripgrep
    rclone
    tldr
    aria2
    fd
  ];
}
