{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./direnv.nix
    ./helix.nix
    ./jujutsu.nix
    ./nushell.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    aria2
    btop
    cloneit
    ncdu
    ripgrep
    rclone
    tldr
    fd
  ];
}
