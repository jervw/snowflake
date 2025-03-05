{
  config,
  lib,
  user,
  ...
}: {
  services.greetd = let
    session = {
      inherit user;
      command = "${config.programs.niri.package}/bin/niri-session &> /dev/null";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  specialisation = {
    hyprland.configuration = {
      services.greetd = let
        session = {
          inherit user;
          command = "${lib.getExe config.programs.hyprland.package} &> /dev/null";
        };
      in {
        settings = {
          default_session = lib.mkForce session;
          initial_session = lib.mkForce session;
        };
      };
    };
  };
}
