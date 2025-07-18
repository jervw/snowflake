{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.terminal.shells.nushell;
in {
  options.${namespace}.programs.terminal.shells.nushell = {
    enable = mkEnableOption "Enable Nushell shell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      extraConfig = ''
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
    };

    programs.nix-your-shell.enable = true;
    programs.carapace.enable = true;
  };
}
