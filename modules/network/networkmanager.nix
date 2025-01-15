{lib, ...}: {
  networking = {
    networkmanager = {
      enable = true;
    };
    wireless.enable = false; # You can still use wifi through NetworkManager
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
