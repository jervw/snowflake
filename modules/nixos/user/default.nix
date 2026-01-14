{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  inherit (config.${namespace}) user;
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
    users.groups.media = {}; # Used for some services on a server system
    users.users.${user.name} =
      {
        inherit (user) name;

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
          ++ user.extraGroups;

        group = "users";
        hashedPasswordFile = "/persist/password";
        isNormalUser = true;
        description = user.fullName;
      }
      // user.extraOptions;
  };
}
