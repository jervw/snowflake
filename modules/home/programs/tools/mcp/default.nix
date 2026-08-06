{
  config,
  lib,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.mcp;
in {
  options.${namespace}.programs.tools.mcp = {
    enable = lib.mkEnableOption "Enable MCP servers";
  };

  config = mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          command = lib.getExe pkgs.context7-mcp;
          env.CONTEXT7_API_KEY.file = config.age.secrets.mcp-context7.path;
          args = [];
        };
        mcp-nixos = {
          command = lib.getExe pkgs.mcp-nixos;
          args = [];
        };
      };
    };

    age.secrets.mcp-context7.file = "${inputs.self}/secrets/mcp-context7.age";
  };
}
