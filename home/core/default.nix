{pkgs, ...}: {
  imports = [
    ./git
    ./fish
    ./helix
    ./tmux
    ./direnv
    ./zellij
  ];

  home.packages = with pkgs; [
    dconf
    bat
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
  ];
}
