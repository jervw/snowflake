{user, ...}: {
  imports = [
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

  networking.hostName = "vidar";
}
