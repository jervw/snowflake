{
  inputs,
  user,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../../modules/core
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = user;
    startMenuLaunchers = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
