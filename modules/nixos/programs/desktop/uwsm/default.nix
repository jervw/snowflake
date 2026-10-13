{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.${namespace}.programs.desktop.uwsm;
  niri = config.programs.uwsm.waylandCompositors.niri;
in {
  options.${namespace}.programs.desktop.uwsm = {
    enable = mkEnableOption "uwsm";
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the uwsm session from greetd";
    };
  };

  config = mkIf cfg.enable {
    programs.uwsm = {
      enable = true;
      # Generates niri-uwsm.desktop, so the session does not depend on state
      # in ~/.config/uwsm. Niri comes from the Home Manager profile.
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/etc/profiles/per-user/${config.${namespace}.user.name}/bin/niri";
        extraArgs = ["--session"];
      };
    };

    ${namespace}.programs.desktop.greetd = mkIf cfg.autoStart {
      enable = true;
      # Same command as the generated niri-uwsm.desktop entry
      sessions = ["uwsm start -F -- ${lib.concatStringsSep " " ([niri.binPath] ++ niri.extraArgs)}"];
    };
  };
}
