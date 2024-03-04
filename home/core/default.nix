{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fish.nix
    ./helix.nix
    ./tmux.nix
    ./direnv.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    dconf
    bat
    btop
    xdg-utils
    rustup
    eza
    pfetch
    ripgrep
    rclone
    fd
    fzf
    nix-search-cli
    any-nix-shell
    yazi
  ];
}
