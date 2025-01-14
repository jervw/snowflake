{pkgs, ...}: {
  home.sessionVariables."SHELL" = "${pkgs.nushell}/bin/nu";

  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        y = "yazi";
        lg = "lazygit";
        l = "eza --icons";
        tree = "eza --tree --icons";
        whereami = "curl ipinfo.io/city";
      };
      extraConfig = ''
        $env.config.buffer_editor = "hx"
        $env.config.show_banner = false
      '';
      plugins = [pkgs.nushellPlugins.highlight];
    };

    # Nix-your-shell
    nix-your-shell = {
      enable = true;
    };

    # Completions
    carapace = {
      enable = true;
    };
    # Prompt
    starship = {
      enable = true;
    };
  };
}
