{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      marksman
      clang-tools
      rust-analyzer
    ];

    settings = {
      theme = "zed_onedark_transparent";
      editor = {
        line-number = "relative";
        bufferline = "always";
        text-width = 100;
        color-modes = true;
        true-color = true;
        undercurl = true;
        smart-tab.enable = false;
        whitespace.characters = {
          tab = "→";
          newline = "⏎";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = ["mode" "spacer" "version-control" "file-name" "file-modification-indicator"];
          right = ["spinner" "diagnostics" "file-encoding" "file-type" "position"];
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        indent-guides.render = true;
        gutters.line-numbers.min-width = 1;
      };
      keys.normal = {
        C-s = ":w";
        C-q = ":bclose";
        A-t = ":toggle lsp.display-inlay-hints";
        A-l = "goto_next_buffer";
        A-h = "goto_previous_buffer";
        X = ["extend_line_up" "extend_to_line_bounds"];
        A-x = "extend_to_line_bounds";
        "0" = "goto_line_start";
        "$" = "goto_line_end";
      };
      keys.select = {
        X = ["extend_line_up" "extend_to_line_bounds"];
        A-x = "extend_to_line_bounds";
      };
    };

    languages = {
      language = with pkgs; [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = lib.getExe alejandra;
            args = ["-q"];
          };
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = lib.getExe rustfmt;
          };
        }
      ];
      language-server = with pkgs; {
        nil = {
          command = lib.getExe nil;
        };
        marksman = {
          command = lib.getExe marksman;
        };
        rust-analyzer = {
          timeout = 120;
          config.check = {
            command = "clippy";
          };
        };
      };
    };
  };

  home = {
    # make background transparent
    file.".config/helix/themes/zed_onedark_transparent.toml".text = ''
      inherits = "zed_onedark"
      "ui.background" = {}
      "ui.virtual.jump-label" = { fg = "yellow", modifiers = ["bold"] }
    '';
  };
}
