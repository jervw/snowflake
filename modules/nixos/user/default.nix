{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with lib.types; {
    name = mkOpt str "jervw" "The name to use for the user account.";
    fullName = mkOpt str "Jere Vuola" "The full name of the user.";
    email = mkOpt str "jervw@pm.me" "The email of the user.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    programs.fish.enable = true; # TODO: Enable elsewhere
    users.groups.media = {}; # Used for some services on a server system
    users.users.${cfg.name} =
      {
        inherit (cfg) name;

        extraGroups =
          [
            "wheel"
            "systemd-journal"
            "audio"
            "video"
            "input"
            "plugdev"
            "tss"
            "power"
            "nix"
          ]
          ++ cfg.extraGroups;

        group = "users";
        hashedPasswordFile = "/persist/password";
        isNormalUser = true;
        shell = pkgs.fish;
        description = cfg.fullName;
      }
      // cfg.extraOptions;
  };
}
