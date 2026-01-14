{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.editors.zed;
in {
  options.${namespace}.programs.editors.zed = {
    enable = lib.mkEnableOption "Enable zed-editor";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      userSettings = {
        agent = {
          play_sound_when_agent_done = true;
          default_model = {
            model = "qwen2.5-coder:7b";
            provider = "ollama";
          };
        };
        helix_mode = true;
        relative_line_numbers = true;

        hour_format = "hour24";
        auto_update = false;

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        lsp = {
          rust-analyzer = {
            binary = {
              path = lib.getExe pkgs.rust-analyzer;
              path_lookup = true;
            };
          };

          nix = {
            binary = {
              path_lookup = true;
            };
          };
        };
      };
    };
  };
}
