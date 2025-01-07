{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      fzf_configure_bindings
      set fish_greeting
    '';

    shellAliases = {
      y = "yazi";
      lg = "lazygit";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };

  home.packages = with pkgs; [
    any-nix-shell
    eza
    bat
    fzf
    fishPlugins.autopair
    fishPlugins.fzf-fish
  ];
}
