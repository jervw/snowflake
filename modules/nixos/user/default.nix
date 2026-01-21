{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkMerge mdDoc;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;
in {
  options.${namespace}.user = {
    name = mkOpt types.str "jervw" "The name to use for the user account.";
    fullName = mkOpt types.str "Jere Vuola" "The full name of the user.";
    email = mkOpt types.str "jervw@pm.me" "The email of the user.";
    initialPassword =
      mkOpt types.str "password"
      "The initial password to use when the user is first created.";
    extraGroups = mkOpt (types.listOf types.str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt types.attrs {} (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    users.groups.media = {}; # Used for some services on a server system

    users.users.${user.name} = mkMerge [
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
        isNormalUser = true;
        description = user.fullName;
      }
      (mkIf config.${namespace}.system.impermanence.enable {
        hashedPasswordFile = "/persist/password";
      })
      user.extraOptions
    ];
  };
}
