{pkgs, ...}: {
  home.sessionVariables = {
    SHELL = "nu";
  };

  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        y = "yazi";
        lg = "lazygit";
        cd = "z";
        whereami = "curl ipinfo.io/city";
      };
      extraConfig = ''
        # Variables
        $env.EDITOR = "hx"

        # Config
        $env.config.buffer_editor = "hx"
        $env.config.show_banner = false
        $env.config.rm.always_trash = true
        $env.config.highlight_resolved_externals = true

        # Fish completer
        let fish_completer = {|spans|
          ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
          | from tsv --flexible --noheaders --no-infer
          | rename value description
        }
      '';
      # plugins = [pkgs.nushellPlugins.highlight];
    };

    # Nix-your-shell
    nix-your-shell.enable = true;

    # Completions
    carapace.enable = true;

    # Prompt
    starship.enable = true;
  };
}
