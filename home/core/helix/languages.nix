{
  pkgs,
  lib,
  ...
}: {
  programs.helix.languages = {
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

      vscode-css-language-server = {
        command = "${nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
        args = ["--stdio"];
      };
    };
  };
}
