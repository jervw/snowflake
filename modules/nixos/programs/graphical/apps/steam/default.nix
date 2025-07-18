{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.steam;
in {
  options.${namespace}.programs.graphical.apps.steam = {
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
