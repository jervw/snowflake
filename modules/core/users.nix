{
  pkgs,
  user,
  ...
}: {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;
    users.${user} = {
      isNormalUser = true;
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
    users.root.hashedPassword = "!"; # disable root password
  };

  services.getty.autologinUser = user;
}
