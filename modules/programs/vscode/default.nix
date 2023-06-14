{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "09j6h0h4lvsh05h92fg66jc4dpfd5nx2mrbs8srdwxpks5gz5s3d";
      });
      version = "latest";
    });
  };
}
