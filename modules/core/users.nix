{
  config,
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
      ];
    };
    users.root.hashedPassword = "!"; # disable root password
  };

  # secrets
  # age.secrets = {
  #   pia = {
  #     file = ../../secrets/pia.age;
  #     owner = user;
  #   };
  # };
}
