{
  pkgs,
  inputs,
  lib,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in {
  home.packages = [quickshell];

  home.sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtbase}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtgraphs}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
  ];
}
