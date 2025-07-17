{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.graphical.wm.hyprland;
in {
  options.${namespace}.programs.graphical.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    # TODO move to a suite
    home.packages = with pkgs; [
      grimblast
      wl-clipboard
      wtype
      wlr-randr
      hyprpicker
      xorg.xeyes
      xorg.xrandr
      xclip
    ];

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
