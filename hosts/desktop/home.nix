# Specific packages for Desktop
{ pkgs, ... }:

{
  #imports = [ ../../modules/desktop/i3 ];

  home = {
    packages = with pkgs; [
      networkmanagerapplet
      steam
      ungoogled-chromium
      vscode
    ];
  };
}
