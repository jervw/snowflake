{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.atuin;
in {
  options.${namespace}.programs.terminal.tools.atuin = {
    enable = lib.mkEnableOption "Enable atuin";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      daemon.enable = true;

      flags = ["--disable-up-arrow"];

      settings = {
        enter_accept = true;
        filter_mode = "workspace";
        keymap_mode = "auto";
        show_preview = true;
        style = "auto";
        update_check = false;
        workspaces = true;

        history_filter = [
          "^(sudo reboot)$"
          "^(sudo poweroff)$"
          "^(poweroff)$"
          "^(reboot)$"
        ];
      };
    };
  };
}
