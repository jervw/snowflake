{
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkOption types;

  modeType = types.submodule {
    options = {
      width = mkOption {
        type = types.ints.positive;
        description = "Horizontal resolution in pixels.";
      };

      height = mkOption {
        type = types.ints.positive;
        description = "Vertical resolution in pixels.";
      };

      refreshRate = mkOption {
        type = types.nullOr types.numbers.positive;
        default = null;
        description = "Optional refresh rate in hertz.";
      };
    };
  };

  positionType = types.submodule {
    options = {
      x = mkOption {
        type = types.int;
        description = "Horizontal position in the global coordinate space.";
      };

      y = mkOption {
        type = types.int;
        description = "Vertical position in the global coordinate space.";
      };
    };
  };

  monitorType = types.submodule {
    options = {
      enabled = mkOption {
        type = types.bool;
        default = true;
        description = "Whether the monitor should be enabled.";
      };

      mode = mkOption {
        type = types.nullOr modeType;
        default = null;
        description = "Optional monitor mode.";
      };

      position = mkOption {
        type = types.nullOr positionType;
        default = null;
        description = "Optional manual monitor position.";
      };

      scale = mkOption {
        type = types.nullOr types.numbers.positive;
        default = null;
        description = "Optional monitor scale factor.";
      };

      transform = mkOption {
        type = types.nullOr (types.enum [
          "normal"
          "90"
          "180"
          "270"
          "flipped"
          "flipped-90"
          "flipped-180"
          "flipped-270"
        ]);
        default = null;
        description = "Optional monitor transform.";
      };

      vrr = mkOption {
        type = types.bool;
        default = false;
        description = "Whether variable refresh rate should be enabled.";
      };
    };
  };
in {
  options.${namespace}.monitors = mkOption {
    type = types.attrsOf monitorType;
    default = {};
    description = "Compositor-independent monitor configuration keyed by connector name.";
  };
}
