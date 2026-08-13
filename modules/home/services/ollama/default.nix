{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = {
    enable = lib.mkEnableOption "Ollama";
  };

  config = lib.mkIf cfg.enable {
    services.ollama.enable = true;
  };
}
