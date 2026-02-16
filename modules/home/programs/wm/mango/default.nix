{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.wm.mango;
in {
  options.${namespace}.programs.wm.mango = {
    enable = mkEnableOption "Enable MangoWC";
    uwsmEntry = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      internal = true;
    };
  };

  imports = [./binds.nix];

  config = mkIf cfg.enable {
    wayland.windowManager.mango = {
      enable = true;
      systemd.enable = false; # uwsm should handle everything
    };

    ${namespace}.programs.wm.mango.uwsmEntry = {
      prettyName = "Mango";
      comment = "Mango compositor managed by UWSM";
      binPath = "${config.wayland.windowManager.mango.package}/bin/mango";
      extraArgs = [];
    };
  };
}
