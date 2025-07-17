{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.lazygit;
in {
  options.${namespace}.programs.terminal.tools.lazygit = {
    enable = lib.mkEnableOption "Enable lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;

      settings = {
        disableStartupPopups = true;
        notARepository = "quit";

        gui = {
          authorColors = {
            "${config.${namespace}.user.fullName}" = "#c6a0f6";
            "dependabot[bot]" = "#eed49f";
          };
          branchColors = {
            main = "#ed8796";
            master = "#ed8796";
            dev = "#8bd5ca";
          };
          nerdFontsVersion = "3";
        };
        git = {
          overrideGpg = true;
        };
      };
    };

    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
