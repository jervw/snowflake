{
  config,
  lib,
  user,
  ...
}: {
  services.greetd = let
    session = {
      inherit user;
      command = "${lib.getExe config.programs.hyprland.package}";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
