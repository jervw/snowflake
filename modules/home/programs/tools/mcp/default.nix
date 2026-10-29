{
  config,
  lib,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) attrNames filterAttrs genAttrs mkEnableOption mkIf;

  cfg = config.${namespace}.programs.tools.mcp;

  # Every server here gets a ${namespace}.programs.tools.mcp.<name> toggle.
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
    github = {
      command = lib.getExe pkgs.github-mcp-server;
      args = ["stdio"];
      env.GITHUB_PERSONAL_ACCESS_TOKEN.file = config.age.secrets.mcp-github.path;
    };
    # zennotes-desktop doesn't ship an MCP wrapper, so run mcp.js with
    # Electron acting as plain Node.
    zennotes = {
      command = "${pkgs.electron_42.unwrapped}/libexec/electron/electron";
      args = ["${pkgs.zennotes-desktop}/lib/node_modules/zennotes-monorepo/apps/desktop/out/main/mcp.js"];
      env.ELECTRON_RUN_AS_NODE = "1";
    };
  };
in {
  options.${namespace}.programs.tools.mcp =
    {
      # Enabled by the modules of programs that consume programs.mcp.
      enable =
        mkEnableOption "MCP servers"
        // {
          internal = true;
        };
    }
    // genAttrs (attrNames servers) (name: mkEnableOption "${name} MCP server" // {default = true;});

  config = mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = filterAttrs (name: _: cfg.${name}) servers;
    };

    # The default path contains a literal ${XDG_RUNTIME_DIR}, which the MCP
    # env-file wrapper single-quotes, so it would never be expanded.
    age.secrets.mcp-context7 = mkIf cfg.context7 {
      file = "${inputs.self}/secrets/mcp-context7.age";
      path = "${config.home.homeDirectory}/.local/state/agenix/mcp-context7";
    };

    age.secrets.mcp-github = mkIf cfg.github {
      file = "${inputs.self}/secrets/mcp-github.age";
      path = "${config.home.homeDirectory}/.local/state/agenix/mcp-github";
    };
  };
}
