{pkgs, ...}: {
  users.users = {
    jervw = {
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
