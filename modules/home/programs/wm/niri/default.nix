{
  lib,
  namespace,
  pkgs,
  config,
  ...
}: let
  cfg = config.${namespace}.programs.wm.niri;
in {
  options.${namespace}.programs.wm.niri = {
    enable = lib.mkEnableOption "Enable niri";
    uwsmEntry = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      internal = true;
    };
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = {
    programs.niri = {
      inherit (cfg) enable;
      package = pkgs.niri-unstable;
    };

    ${namespace}.programs.wm.niri.uwsmEntry = lib.mkIf cfg.enable {
      prettyName = "Niri";
      comment = "Niri compositor managed by UWSM";
      binPath = "${config.programs.niri.package}/bin/niri-session";
      extraArgs = [];
    };
  };
}
