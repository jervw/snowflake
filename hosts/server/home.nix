# Specific packages for Desktop
{ pkgs, ... }:

{
  imports = [
    ../../modules/programs
  ];

  home = {
    packages = with pkgs; [
    ];
  };
}
