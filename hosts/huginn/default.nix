{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disks.nix
    ../../modules/core
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "huginn";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
  };

  services = {
    searx = {
      enable = true;
      settings = {
        server = {
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "changeme";
        };
      };
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."search.jervw.dev" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8888";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jervw@pm.me";
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
}
