{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.hardware.video.lact;
in {
  options.${namespace}.hardware.video.lact = {
    enable = lib.mkEnableOption "Support for GPU overclocking";
  };

  config = mkIf cfg.enable {
    services.lact = {
      enable = true;
      # TODO, add settings, also add it as an own option
      # settings = {};
    };
  };
}
