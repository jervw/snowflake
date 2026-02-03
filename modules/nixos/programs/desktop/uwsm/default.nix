{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types mapAttrs' nameValuePair filterAttrs;
  cfg = config.${namespace}.programs.desktop.uwsm;

  hmUser = config.home-manager.users.jervw;

  # Collect all compositor uwsm entries from home-manager
  uwsmEntries = {
    niri = hmUser.${namespace}.programs.wm.niri.uwsmEntry or null;
    hyprland = hmUser.${namespace}.programs.wm.hyprland.uwsmEntry or null;
  };

  # Filter out null entries
  waylandCompositors = mapAttrs' (
    name: entry:
      nameValuePair name entry
  ) (filterAttrs (_: entry: entry != null) uwsmEntries);
in {
  options.${namespace}.programs.desktop.uwsm = {
    enable = mkEnableOption "uwsm";
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to autostart uwsm";
    };
  };

  config = mkIf cfg.enable {
    programs.uwsm = {
      enable = true;
      inherit waylandCompositors;
    };

    # TODO: Workaround for https://github.com/NixOS/nixpkgs/issues/485123
    services.displayManager.cosmic-greeter.enable = true;
    # programs.fish.loginShellInit = mkIf cfg.autoStart ''
    #   if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
    #     exec uwsm start default
    #   end
    # '';
  };
}
