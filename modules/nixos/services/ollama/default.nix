{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = {
    enable = mkEnableOption "Enable Ollama";
    modelsPath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Custom path for Ollama models, if not set upstream default will be used";
    };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      modelsDir = mkIf (cfg.modelsPath != null) cfg.modelsPath;
    };
  };
}
