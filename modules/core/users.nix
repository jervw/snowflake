{pkgs, ...}: {
  programs.fish.enable = true;
  users.users = {
    jervw = {
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
