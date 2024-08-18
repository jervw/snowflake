{
  inputs,
  user,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../../modules/core
    ../../modules/network/syncthing.nix
  ];

  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };
    defaultUser = user;
    startMenuLaunchers = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
