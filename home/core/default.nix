{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./fish.nix
    ./direnv.nix
    ./helix.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    dconf
    bat
    btop
    cloneit
    xdg-utils
    eza
    ncdu
    ripgrep
    rclone
    fd
    fzf
    any-nix-shell
  ];
}
