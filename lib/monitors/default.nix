{lib, ...}: let
  inherit (lib) mapAttrsToList optionalAttrs optionalString;

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
in {
  monitors.toNiri = monitors: mapAttrsToList toNiriOutput monitors;
}
