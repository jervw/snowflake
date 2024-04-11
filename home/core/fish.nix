{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting # Disable greeting
    '';

    shellAliases = {
      doas = "sudo";
      nvim = "hx";
      nano = "hx";
      lg = "lazygit";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };

  home.packages = with pkgs; [
    fishPlugins.autopair
    fishPlugins.fzf
  ];
}
