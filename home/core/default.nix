{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fish.nix
    ./helix.nix
    ./tmux.nix
    ./direnv.nix
    ./zellij.nix
    ./zoxide.nix
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
    any-nix-shell
    yazi
  ];
}
