{inputs, ...}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    kernelParams = ["quiet" "splash"];
    consoleLogLevel = 0;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd = {
      verbose = false;
      systemd = {
        enable = true;
        enableTpm2 = true;
      };
    };
    loader = {
      timeout = 4;
    };
  };
}
