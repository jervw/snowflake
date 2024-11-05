{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./direnv.nix
    ./helix.nix
    ./nushell.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    dconf
    bat
    btop
    xdg-utils
    eza
    ncdu
    ripgrep
    rclone
    fd
    fzf
    nix-your-shell
  ];
}
