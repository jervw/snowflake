{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.starship;
in {
  options.${namespace}.programs.tools.starship = {
    enable = lib.mkEnableOption "Enable starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      extraPackages = [pkgs.jj-starship];
      settings = {
        git_branch.disabled = true;
        git_status.disabled = true;

        custom = {
          jj = {
            when = "jj-starship detect";
            shell = ["jj-starship"];
            format = "$output ";
          };
        };
      };
    };
  };
}
