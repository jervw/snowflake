{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages."x86_64-linux".default;
    defaultEditor = true;

    # Zero-conf packages
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      gopls
      markdown-oxide
      clippy
    ];

    settings = {
      theme = "zed_onedark";
      editor = {
        line-number = "relative";
        bufferline = "always";
        text-width = 100;
        color-modes = true;
        true-color = true;
        undercurl = true;
        smart-tab.enable = false;
        lsp.display-inlay-hints = false;
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        whitespace.characters = {
          tab = "→";
          newline = "⏎";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        gutters.line-numbers.min-width = 1;
      };
      keys.normal = {
        C-q = ":bclose";
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
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nixd"];
          formatter = {
            command = lib.getExe pkgs.alejandra;
            args = ["-q"];
          };
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["pyright" "ruff"];
          auto-format = true;
        }
        {
          name = "typescript";
          shebangs = ["deno"];
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = ["deno-lsp"];
        }
      ];

      # LSP's
      language-server = {
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = ["-std=c++2b"];
        };
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          timeout = 120;
          config.check = {
            command = "clippy";
          };
        };
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = ["--stdio"];
          config = {
            reportUnusedImport = true;
            reportMissingTypeStubs = false;
            python.analysis = {
              typeCheckingMode = "basic";
              autoImportCompletions = true;
            };
          };
        };
        ruff = {
          command = "${pkgs.ruff}/bin/ruff";
          args = ["server"];
        };
        vscode-html-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
          args = ["--stdio"];
        };
        vscode-json-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = ["--stdio"];
        };
        vscode-css-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = ["--stdio"];
        };
        deno-lsp = {
          command = "${pkgs.deno}/bin/deno";
          args = ["lsp"];
          config.deno = {
            enable = true;
            unstable = true;
            suggest.imports.hosts = {
              "https://deno.land" = true;
            };
            inlayHints = {
              parameterNames.enabled = "all";
              parameterTypes.enabled = true;
              variableTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              functionLikeReturnTypes.enabled = true;
              enumMemberValues.enabled = true;
            };
          };
        };
      };
    };
  };
}
