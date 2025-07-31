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

  # imports = mkIf cfg.enable (lib.snowfall.fs.get-non-default-nix-files ./.);

  config = mkIf cfg.enable {
    home.packages = [pkgs.xwayland-satellite];

    programs.niri = {
      enable = true;
      package = inputs.niri.packages.${system}.niri-unstable;
    };
  };
}
