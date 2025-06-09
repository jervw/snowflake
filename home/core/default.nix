{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./fish.nix
    ./direnv.nix
    ./helix.nix
    # ./nushell.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    aria2
    btop
    caligula
    cloneit
    ncdu
    ripgrep
    rclone
    tldr
    fd
  ];
}
