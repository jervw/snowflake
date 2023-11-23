{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting # Disable greeting
      direnv hook fish | source
    '';

    shellAliases = {
      nvim = "hx";
      nano = "hx";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };
}
