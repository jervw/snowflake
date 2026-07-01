{
  lib,
  namespace,
  pkgs,
  config,
  ...
}: let
  cfg = config.${namespace}.programs.desktop.niri;
in {
  options.${namespace}.programs.desktop.niri = {
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

    ${namespace}.programs.desktop.niri.uwsmEntry = lib.mkIf cfg.enable {
      prettyName = "Niri";
      comment = "Niri compositor managed by UWSM";
      binPath = "${config.programs.niri.package}/bin/niri-session";
      extraArgs = [];
    };
  };
}
