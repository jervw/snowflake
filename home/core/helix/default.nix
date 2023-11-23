{ ... }:

{
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
          left = [ "mode" "spacer" "version-control" "file-name" "file-modification-indicator" ];
          right = [ "spinner" "diagnostics" "file-encoding" "file-type" "position" ];
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
        X = [ "extend_line_up" "extend_to_line_bounds" ];
        A-x = "extend_to_line_bounds";
        space.u.h = ":toggle lsp.display-inlay-hints";
      };

      keys.select = {
        X = [ "extend_line_up" "extend_to_line_bounds" ];
        A-x = "extend_to_line_bounds";
      };
    };
  };

  # make background transparent
  home.file.".config/helix/themes/nightfox_transparent.toml".text = ''
    inherits = "nightfox"
    "ui.background" = {}
  '';
}
