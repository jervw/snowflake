{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.gaming;
in {
  options.${namespace}.suites.gaming = {
    enable = mkEnableOption "Gaming configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}; [
      osu-lazer-bin
      osu-mime
    ];

    snowflake = {
      programs = {
        addons = {
          gamescope = mkDefault enabled;
          ntsync = mkDefault enabled;
        };
        apps = {
          steam = mkDefault enabled;
        };
      };
    };
  };
}
