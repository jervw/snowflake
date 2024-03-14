{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    brightnessctl
    gtk3
  ];

  programs.ags = {
    enable = true;
  };
}
