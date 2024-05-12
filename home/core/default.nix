{pkgs, ...}: {
  imports = [
    ./git.nix
    ./fish.nix
    ./direnv.nix
    ./lazygit.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    amp
    dconf
    bat
    btop
    xdg-utils
    eza
    pfetch
    ripgrep
    rclone
    fd
    fzf
    any-nix-shell
  ];
}
