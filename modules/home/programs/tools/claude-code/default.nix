{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.claude-code;
  # A non-default configDir makes Home Manager export CLAUDE_CONFIG_DIR, which
  # also moves ~/.claude.json inside it, keeping all state in one directory.
  configDir = "${config.xdg.configHome}/claude";
  settingsPath = "${configDir}/settings.json";
  staticSettings =
    config.programs.claude-code.settings
    // {"$schema" = "https://json.schemastore.org/claude-code-settings.json";};
  staticConfig = (pkgs.formats.json {}).generate "claude-code-settings.json" staticSettings;
in {
  options.${namespace}.programs.tools.claude-code = {
    enable = lib.mkEnableOption "Enable Claude Code";
  };

  config = mkIf cfg.enable {
    # Home Manager otherwise symlinks settings.json into /nix/store. Claude Code
    # writes to this file, e.g. when changing the model with /model.
    home.file.${settingsPath}.enable = false;

    home.activation.claudeCodeMutableSettings = config.lib.dag.entryAfter ["linkGeneration"] ''
      settingsFile=${lib.escapeShellArg settingsPath}
      staticConfig=${lib.escapeShellArg staticConfig}

      # Preserve Claude-written entries from the previous writable copy. A
      # symlink from an older generation points into the store and is ignored.
      existingSettings=/dev/null
      if [ -f "$settingsFile" ] && [ ! -L "$settingsFile" ]; then
        existingSettings="$settingsFile"
      fi

      mergedSettings="$(mktemp)"
      ${lib.getExe pkgs.jq} -s 'reduce .[] as $item ({}; . * $item)' \
        "$existingSettings" "$staticConfig" > "$mergedSettings"
      install -Dm644 "$mergedSettings" "$settingsFile"
      rm -f "$mergedSettings"
    '';

    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
      context = ../AGENTS.md;
      inherit configDir;
      settings = {
        model = "opus";
      };
    };
  };
}
