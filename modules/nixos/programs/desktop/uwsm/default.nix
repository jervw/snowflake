{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.${namespace}.programs.desktop.uwsm;
in {
  options.${namespace}.programs.desktop.uwsm = {
    enable = mkEnableOption "uwsm";
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable greetd for logging in to the uwsm sessions";
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

    ${namespace}.programs.desktop.greetd.enable = mkIf cfg.autoStart true;
  };
}
