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
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = {
    programs.niri = {
      inherit (cfg) enable;
      package = pkgs.niri-unstable;
    };
  };
}
