{ pkgs, ... }:

{
programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    shellAliases = {
      ls = "exa --icons";
      tree = "exa --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };
}
