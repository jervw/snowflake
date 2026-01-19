{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.wm.hyprland;
in {
  options.${namespace}.programs.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    uwsmEntry = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      internal = true;
    };
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    services.hyprpolkitagent = enabled;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false; # uwsm should handle everything
      plugins = with pkgs.hyprlandPlugins; [
        # hyprexpo
      ];
    };

    ${namespace}.programs.wm.hyprland.uwsmEntry = mkIf cfg.enable {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "${config.wayland.windowManager.hyprland.package}/bin/start-hyprland";
      extraArgs = [];
    };
  };
}
