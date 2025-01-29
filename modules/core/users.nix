{pkgs, ...}: {
  users.users.root.hashedPassword = "!"; # Disable root password
  users.users = {
    jervw = {
      hashedPasswordFile = "/persist/password";
      isNormalUser = true;
      shell = pkgs.nushell;
      extraGroups = [
        "networkmanager"
        "wheel"
        "disk"
        "video"
        "input"
        "media"
      ];
    };
  };
}
