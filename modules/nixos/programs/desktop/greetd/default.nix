{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.desktop.greetd;
  user = config.${namespace}.user.name;
  greeter = config.services.greetd.settings.default_session.user;
in {
  options.${namespace}.programs.desktop.greetd = {
    enable = lib.mkEnableOption "Enable greetd with Noctalia Greeter";
  };

  config = mkIf cfg.enable {
    # Sessions are discovered from /run/current-system/sw/share/wayland-sessions,
    # and the last selected one is remembered in sync.toml.
    services.displayManager.noctalia-greeter = {
      enable = true;
      # Lets Noctalia's greeter sync run without an admin prompt
      passwordlessSyncUsers = [user];
      cursorTheme = {
        package = pkgs.bibata-cursors-translucent;
        name = "Bibata_Ghost";
      };
      settings = {
        cursor.size = 28;
        keyboard = {
          layout = "us";
          options = "compose:ralt,caps:none";
        };
      };
    };

    # Unlock the keyring with the login password
    security.pam.services.greetd.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;

    # Synced appearance, wallpapers and the remembered session, plus the
    # AccountsService avatar shown in the user list
    environment.persistence."/persist".directories = mkIf config.${namespace}.system.impermanence.enable [
      {
        directory = "/var/lib/noctalia-greeter";
        user = greeter;
        inherit (config.users.users.${greeter}) group;
        mode = "0750";
      }
      {
        directory = "/var/lib/AccountsService";
        mode = "0775";
      }
    ];
  };
}
