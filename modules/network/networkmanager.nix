{lib, ...}: {
  networking.networkmanager = {
    enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
