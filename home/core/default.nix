{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./direnv.nix
    ./helix.nix
    ./nushell.nix
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
    fd
  ];
}
