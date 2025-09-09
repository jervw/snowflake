{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.gpu-screen-recorder;
in {
  options.${namespace}.programs.graphical.apps.gpu-screen-recorder = {
    enable = lib.mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [gpu-screen-recorder-gtk];
    };

    programs.gpu-screen-recorder = {
      enable = true;
    };
  };
}
