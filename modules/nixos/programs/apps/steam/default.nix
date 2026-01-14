{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.steam;
in {
  options.${namespace}.programs.apps.steam = {
    enable = lib.mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [steamtinkerlaunch];
    };

    programs.steam = {
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };
}
