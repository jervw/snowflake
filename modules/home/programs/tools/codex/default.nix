{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.codex;
  configPath = ".config/codex/config.toml";
  transformedMcpServers = lib.optionalAttrs (config.programs.codex.enableMcpIntegration && config.programs.mcp.enable) (
    lib.mapAttrs (
      name: server:
      config.lib.mcp.transformMcpServer {
        inherit server;
        exclude = ["headers" "type"];
        extraTransforms = [
          (s: s // lib.optionalAttrs (s.headers or {} != {}) {http_headers = s.headers;})
          config.lib.mcp.addType
          (config.lib.mcp.wrapEnvFilesCommand {inherit pkgs name;})
        ];
      }
    ) config.programs.mcp.servers
  );
  staticSettings = lib.recursiveUpdate
    {mcp_servers = transformedMcpServers;}
    config.programs.codex.settings;
  staticConfig = (pkgs.formats.toml {}).generate "codex-config" staticSettings;
in {
  options.${namespace}.programs.tools.codex = {
    enable = lib.mkEnableOption "Enable OpenAI Codex";
  };

  config = mkIf cfg.enable {
    # TODO: Check periodically whether this is fixed upstream
    # Home Manager otherwise symlinks config.toml into /nix/store. Codex writes
    # trust_level entries to this file when directories are trusted in the TUI.
    home.file.${configPath}.enable = false;

    home.activation.codexMutableConfig = config.lib.dag.entryAfter ["linkGeneration"] ''
      configFile=${lib.escapeShellArg "${config.home.homeDirectory}/${configPath}"}
      staticConfig=${lib.escapeShellArg staticConfig}

      # Preserve Codex-written entries from the previous writable copy. A
      # symlink from an older generation points into the store and is ignored.
      existingConfig=/dev/null
      if [ -f "$configFile" ] && [ ! -L "$configFile" ]; then
        existingConfig="$configFile"
      fi

      mergedConfig="$(mktemp)"
      ${lib.getExe pkgs.yq-go} -p toml -o toml eval-all \
        '. as $item ireduce ({}; . * $item)' \
        "$existingConfig" "$staticConfig" > "$mergedConfig"
      install -Dm644 "$mergedConfig" "$configFile"
      rm -f "$mergedConfig"
    '';

    programs.codex = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        model = "gpt-5.6-luna";
        model_reasoning_effort = "medium";

        projects = {
          "/home/jervw/dev".trust_level = "trusted";
          "/home/jervw/.dots".trust_level = "trusted";
        };
      };
    };
  };
}
