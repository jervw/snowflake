{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.codex;
in {
  options.${namespace}.programs.tools.codex = {
    enable = lib.mkEnableOption "Enable OpenAI Codex";
  };

  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        model = "gpt-5.6-luna";
        model_reasoning_effort = "medium";
      };
    };
  };
}
