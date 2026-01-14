{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.wm.hyprland;
in {
  options.${namespace}.programs.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    services.hyprpolkitagent = enabled;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enableXdgAutostart = true;
        variables = ["--all"];
      };
    };
  };
}
