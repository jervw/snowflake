{
  config,
  lib,
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
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    users.users.${cfg.name} =
      {
        inherit (cfg) name initialPassword;

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
        isNormalUser = true;
        description = cfg.fullName;
      }
      // cfg.extraOptions;
  };
}
