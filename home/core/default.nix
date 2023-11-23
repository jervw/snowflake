{ pkgs, ...}:

{
  imports = [
    ./git
    ./fish
    ./helix
    ./tmux
    ./direnv
  ];

  home.packages = with pkgs; [
    dconf
    bat
    xdg-utils
    eza
    pfetch
    ripgrep
    fd
    fzf
    nix-search-cli
    any-nix-shell
  ];
}
