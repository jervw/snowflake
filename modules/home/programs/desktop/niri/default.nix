{
  lib,
  namespace,
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

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      systemd.enable = false;
    };

    # ${namespace}.programs.desktop.niri.uwsmEntry = {
    #   prettyName = "Niri";
    #   comment = "Niri compositor managed by UWSM";
    #   binPath = "${config.programs.niri.package}/bin/niri-session";
    #   extraArgs = [];
    # };
  };
}
