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
      initialPassword = user;
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
}
