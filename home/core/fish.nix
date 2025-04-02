{pkgs, ...}: {
  home = {
    sessionVariables.SHELL = "fish";
    packages = with pkgs; [
      any-nix-shell
      eza
      bat
      fzf
      fishPlugins.autopair
      fishPlugins.fzf-fish
    ];
  };

  programs = {
    fish = {
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
        cd = "z";
        tree = "eza --tree --icons";
        whereami = "curl ipinfo.io/city";
      };
    };

    # Prompt
    starship.enable = true;
  };
}
