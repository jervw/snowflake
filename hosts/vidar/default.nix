{
  inputs,
  user,
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
}
