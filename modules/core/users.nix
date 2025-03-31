{pkgs, ...}: {
  programs.fish.enable = true;

  users.users.root.hashedPassword = "!"; # Disable root password
  users.users = {
    jervw = {
      hashedPasswordFile = "/persist/password";
      isNormalUser = true;
      shell = pkgs.fish;
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
