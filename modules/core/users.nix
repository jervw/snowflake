{pkgs, ...}: {
  users.users = {
    root.hashedPassword = "!"; # disable root password
    jervw = {
      isNormalUser = true;
      shell = pkgs.nushell;
      hashedPasswordFile = "/persist/secrets/jervw";
      extraGroups = [
        "networkmanager"
        "wheel"
        "doas"
        "disk"
        "video"
        "input"
        "media"
      ];
    };
  };
}
