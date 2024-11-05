_: {
  home.sessionVariables.SHELL = "nu";

  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        lg = "lazygit";
        l = "eza --icons";
        tree = "eza --tree --icons";
        whereami = "curl ipinfo.io/city";
      };

      extraConfig = ''
        def _nix_your_shell (command: string, args: list<string>) {
          if not (which nix-your-shell | is-empty) {
            let args = ["--"] ++ $args
            run-external nix-your-shell nu $command ...$args
          } else {
            run-external $command ...$args
          }
        }

        def --wrapped nix-shell (...args) {
          _nix_your_shell nix-shell $args
        }

        def --wrapped nix (...args) {
          _nix_your_shell nix $args
        }

        $env.config = {
          show_banner: false,
          completions: {
            algorithm: "fuzzy",
          },
          history: {
            sync_on_enter: true,
          },
        }
      '';
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
