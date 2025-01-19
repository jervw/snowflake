{pkgs, ...}: {
  home.sessionVariables = {
    SHELL = "nu";
    EDITOR = "hx";
  };

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

        # Fish completer
        let fish_completer = {|spans|
          ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
          | from tsv --flexible --noheaders --no-infer
          | rename value description
        }
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
