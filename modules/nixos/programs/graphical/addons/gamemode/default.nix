{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.programs.graphical.addons.gamemode;

  defaultStartScript = ''
    ${lib.getExe' pkgs.libnotify "notify-send"} 'GameMode started'
  '';

  defaultEndScript = ''
    ${lib.getExe' pkgs.libnotify "notify-send"} 'GameMode ended'
  '';
in {
  options.${namespace}.programs.graphical.addons.gamemode = {
    enable = lib.mkEnableOption "gamemode";
    endscript = mkOpt (with lib.types; nullOr str) null "The script to run when disabling gamemode.";
    startscript = mkOpt (with lib.types; nullOr str) null "The script to run when enabling gamemode.";
  };

  # TODO: Add Hyprland scripts (to hyprland module somewhere)
  # TODO Add GPU overclocking when there is a easy way to do it on Wayland + NVIDIA

  config = let
    startScript =
      if (cfg.startscript == null)
      then pkgs.writeShellScript "gamemode-start" defaultStartScript
      else pkgs.writeShellScript "gamemode-start" cfg.startscript;
    endScript =
      if (cfg.endscript == null)
      then pkgs.writeShellScript "gamemode-end" defaultEndScript
      else pkgs.writeShellScript "gamemode-end" cfg.endscript;
  in
    lib.mkIf cfg.enable {
      programs.gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };

          custom = {
            start = startScript.outPath;
            end = endScript.outPath;
          };
        };
      };

      security.wrappers.gamemode = {
        owner = "root";
        group = "root";
        source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
        capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
      };
    };
}
