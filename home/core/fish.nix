{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      fzf_configure_bindings
      set fish_greeting
    '';

    shellAliases = {
      c = "z";
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
