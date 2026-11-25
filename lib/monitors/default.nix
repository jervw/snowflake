{lib, ...}: let
  inherit (lib) mapAttrs mapAttrsToList optionalAttrs optionalString;

  formatMode = mode:
    "${toString mode.width}x${toString mode.height}"
    + optionalString (mode.refreshRate != null) "@${builtins.toJSON mode.refreshRate}";

  toNiriOutput = name: monitor: {
    output =
      {
        _args = [name];
      }
      // (
        if !monitor.enabled
        then {
          off = {};
        }
        else
          optionalAttrs (monitor.mode != null) {
            mode = formatMode monitor.mode;
          }
          // optionalAttrs (monitor.position != null) {
            position._props = monitor.position;
          }
          // optionalAttrs (monitor.scale != null) {
            inherit (monitor) scale;
          }
          // optionalAttrs (monitor.transform != null) {
            inherit (monitor) transform;
          }
          // optionalAttrs monitor.vrr {
            variable-refresh-rate = {};
          }
      );
  };

  toUmbrielOutput = monitor:
    if !monitor.enabled
    then {
      enabled = false;
    }
    else
      optionalAttrs (monitor.mode != null) {
        mode = formatMode monitor.mode;
      }
      // optionalAttrs (monitor.position != null) {
        position = [monitor.position.x monitor.position.y];
      }
      // optionalAttrs (monitor.scale != null) {
        inherit (monitor) scale;
      }
      // optionalAttrs (monitor.transform != null) {
        inherit (monitor) transform;
      }
      // optionalAttrs monitor.vrr {
        vrr = "always";
      };
in {
  monitors = {
    toNiri = monitors: mapAttrsToList toNiriOutput monitors;
    toUmbriel = monitors: mapAttrs (_: toUmbrielOutput) monitors;
  };
}
