{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.bars.quickshell;
in {
  options.${namespace}.programs.graphical.bars.quickshell = {
    enable = lib.mkEnableOption "Enable quickshell";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [cava wallust];
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
      configs.default = inputs.quickshell-config;
      activeConfig = "default";
      systemd.enable = true;
    };
  };
}
