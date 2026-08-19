{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.shells.nushell;
in {
  options.${namespace}.programs.shells.nushell = {
    enable = mkEnableOption "Enable Nushell shell";
  };

  config = mkIf cfg.enable {
    home.shell.enableNushellIntegration = true;
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        buffer_editor = "hx";
        highlight_resolved_externals = true;
        rm.always_trash = true;

        completions.external = {
          enable = true;
          max_results = 200;
        };
      };
      extraConfig = ''
        # Fish completer
        let fish_completer = {|spans|
          ^${lib.getExe pkgs.fish} --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
          | from tsv --flexible --noheaders --no-infer
          | rename value description
          | update value {|row|
            let value = $row.value
            let needs_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' '`'] | any {$in in $value}

            if ($needs_quote and ($value | path exists)) {
              let expanded_path = if ($value starts-with ~) {
                $value | path expand --no-symlink
              } else {
                $value
              }

              $'"($expanded_path | str replace --all "\"" "\\\"")"'
            } else {
              $value
            }
          }
        }

        $env.config.completions.external.completer = $fish_completer
      '';
    };
  };
}
