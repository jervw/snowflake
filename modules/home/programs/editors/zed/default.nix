{
  config,
  lib,
  pkgs,
  inputs,
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
      extraPackages = with pkgs; [
        direnv
      ];

      # Don't allow changes in Zed editor
      mutableUserSettings = false;
      # mutableUserKeymaps = false;
      # mutableUserTasks = false;
      # mutableUserDebug = false;

      extensions = [
        # Languages
        "toml"
        "nix"
        "python-requirements"
        "git-firefly"

        # Themes and icons
        "colored-zed-icons-theme"

        # Snippets
        "rust-snippets"
      ];

      userSettings = {
        # Appearance
        theme = {
          mode = "system";
          light = "Noctalia Light";
          dark = "Noctalia Dark";
        };
        icon_theme = {
          mode = "system";
          light = "Colored Zed Icons Theme Light";
          dark = "Colored Zed Icons Theme Dark";
        };
        ui_font_size = 16;
        buffer_font_size = 15;
        buffer_font_family = "JetBrainsMono Nerd Font";

        helix_mode = true;
        base_keymap = "VSCode";
        relative_line_numbers = "enabled";
        autosave = "on_focus_change";
        hour_format = "hour24";
        auto_update = false;
        on_last_window_closed = "quit_app";
        which_key.enabled = true;
        diagnostics.inline.enabled = true;
        git.inline_blame.delay_ms = 1000;
        session.trust_all_worktrees = true;
        load_direnv = "shell_hook";

        # Disable collab button from dock
        collaboration_panel.button = false;

        # Agent
        agent = {
          play_sound_when_agent_done = true;
          default_model = {
            provider = "ollama";
            model = "qwen2.5-coder:7b";
          };
        };

        # Node
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        # Disable telemetry
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        languages = {
          Nix = {
            language_servers = ["nixd" "!nil"]; # Disable nil
            formatter.external = {
              command = lib.getExe pkgs.alejandra;
              arguments = ["--quiet" "--"];
            };
          };
        };

        # MCP
        context_servers = {
          mcp-nixos = {
            command = lib.getExe pkgs.mcp-nixos;
            args = [];
          };
        };

        # LSP
        lsp = {
          rust-analyzer = {
            binary.path = lib.getExe pkgs.rust-analyzer;
          };
          nixd = {
            binary.path = lib.getExe pkgs.nixd;
          };
        };
      };
    };
  };
}
