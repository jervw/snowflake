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

  config = mkIf cfg.enable (
    let
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    in {
      home = {
        packages = [quickshell];

        sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
          "${quickshell}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtbase}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtgraphs}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
        ];
      };
    }
  );
}
