{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) disabled;

  cfg = config.${namespace}.programs.graphical.bars.quickshell;
in {
  options.${namespace}.programs.graphical.bars.quickshell = {
    enable = lib.mkEnableOption "Enable quickshell";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [cava matugen];
      sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
        "${pkgs.quickshell}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtbase}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtgraphs}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
        "${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
      ];
    };

    programs.quickshell = {
      enable = true;
      configs.default = inputs.noctalia-shell;
      activeConfig = "default";
      systemd.enable = true;
    };

    services.hyprpaper.enable = lib.mkForce false;

    snowflake = {
      programs = {
        defaults = {
          launcher = "qs ipc call appLauncher toggle";
          lock = "qs ipc call lockScreen toggle";
        };
        graphical = {
          addons = {
            hyprlock = disabled;
            swaync = disabled;
          };
          bars = {
            waybar = disabled;
          };
          launchers = {
            # Dont disable even when using quickshell as launcher, as some other software still depend on fuzzel like bemoji and clipman
            # fuzzel = disabled;
          };
        };
      };
    };
  };
}
