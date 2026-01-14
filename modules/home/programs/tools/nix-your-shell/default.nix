{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.nix-your-shell;
in {
  options.${namespace}.programs.tools.nix-your-shell = {
    enable = lib.mkEnableOption "Enable nix-your-shell";
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell = {
      enable = true;
    };
  };
}
