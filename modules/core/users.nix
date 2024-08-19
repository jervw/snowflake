{pkgs, ...}: {
  programs.fish.enable = true;

  users.users = {
    root.hashedPassword = "!"; # disable root password
    jervw = {
      isNormalUser = true;
      shell = pkgs.fish;
      hashedPasswordFile = "/nix/persist/secrets/jervw";
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
