{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting # Disable greeting
    '';

    shellAliases = {
      nvim = "hx";
      nano = "hx";
      ls = "exa --icons";
      tree = "exa --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };
}
