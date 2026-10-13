{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.claude-code;
  configDir = "${config.xdg.configHome}/claude";
in {
  options.${namespace}.programs.tools.claude-code = {
    enable = lib.mkEnableOption "Enable Claude Code";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
      # Claude Code writes to settings.json, e.g. when changing the model with /model.
      mutableSettings = true;
      context = ../AGENTS.md;
      inherit configDir;
      settings = {
        # Recommended advisor setup: Sonnet does the work and consults Opus.
        # The advisor must be at least as capable as the main model.
        model = "sonnet";
        advisorModel = "opus";

        # No Claude attribution (Co-Authored-By trailer, PR footer) in git.
        attribution = {
          commit = "";
          pr = "";
        };

        # Keep secrets out of the Read tool. Allow rules are left to the TUI,
        # since the activation merge would overwrite arrays written at runtime.
        permissions.deny = [
          "Read(~/.ssh/**)"
          "Read(~/.gnupg/**)"
          "Read(~/.local/state/agenix/**)"
          "Read(//run/user/*/agenix/**)"
          "Read(//run/agenix/**)"
        ];
      };
    };
  };
}
