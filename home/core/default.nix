{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./fish.nix
    ./direnv.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    dconf
    bat
    btop
    xdg-utils
    gh
    eza
    fastfetch
    ripgrep
    rclone
    fd
    fzf
    any-nix-shell
  ];
}
