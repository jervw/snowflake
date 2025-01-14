{pkgs, ...}: {
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
