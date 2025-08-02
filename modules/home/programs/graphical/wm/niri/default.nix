{
  config,
  lib,
  pkgs,
  inputs,
  system,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.wm.niri;
in {
  options.${namespace}.programs.graphical.wm.niri = {
    enable = mkEnableOption "Enable niri";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    home.packages = [pkgs.xwayland-satellite];

    programs.niri = {
      enable = cfg.enable;
      package =
        if cfg.enable
        then inputs.niri.packages.${system}.niri-unstable
        else null;
    };
  };
}
