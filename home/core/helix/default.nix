{pkgs, ...}: {
  imports = [
    ./languages.nix
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "nightfox_transparent";
      editor = {
        line-number = "relative";
        bufferline = "always";
        text-width = 100;
        color-modes = true;
        true-color = true;
        undercurl = true;
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
      };

      keys.select = {
        X = ["extend_line_up" "extend_to_line_bounds"];
        A-x = "extend_to_line_bounds";
        "0" = "goto_line_start"; # Note that this will not work because 0 will be taken as a count
        "$" = "goto_line_end";
      };
    };
  };

  home = {
    # make background transparent
    file.".config/helix/themes/nightfox_transparent.toml".text = ''
      inherits = "nightfox"
      "ui.background" = {}
    '';
  };
}
