{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      nix-your-shell fish | source
      fzf_configure_bindings
      set fish_greeting
    '';

    shellAliases = {
      lg = "lazygit";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };

  home.packages = with pkgs.fishPlugins; [
    hydro
    autopair
    fzf-fish
  ];
}
