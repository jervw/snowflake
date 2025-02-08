{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    # Zero-conf packages
    extraPackages = with pkgs; [
      gopls
      marksman
      markdown-oxide
      clippy
    ];

    settings = {
      theme = lib.mkDefault "zed_onedark";
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
        S-h = "goto_previous_buffer";
        S-l = "goto_next_buffer";
        A-w = "move_next_sub_word_start";
        A-b = "move_prev_sub_word_start";
        A-e = "move_next_sub_word_end";
        A-E = "move_prev_sub_word_end";
        C-w.x = ":bc";
        X = "extend_line_above";
      };
      keys.normal.space = {
        c = ":lsp-workspace-command";
        o = ":sh gh repo view --web";
      };
      keys.select = {
        X = "extend_line_above";
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
          name = "markdown";
          language-servers = ["markdown-oxide" "marksman"];
        }
        {
          name = "typescript";
          shebangs = ["deno"];
          roots = ["deno.json" "deno.jsonc" "package.json"];
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
          # BUG This should work to get the options from home-manager NixOS module but doesn't due to some upstream Nix bug
          # config.options = let
          #   options = "(builtins.getFlake \"${self}\").nixosConfigurations.loki.options";
          # in {
          #   nixos.expr = options;
          #   home-manager.expr = options + ".home-manager.users.type.getSubOptions []";
          # };
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
