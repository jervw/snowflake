{user, ...}: {
  services.syncthing = {
    enable = true;
    inherit user;

    dataDir = "/home/${user}/.sync"; # we dont use this
  };
}
