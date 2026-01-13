{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (self.lib) mkHost;
    user = "jervw";
  in {
    loki = mkHost {
      hostname = "loki";
      inherit user;
    };
    thor = mkHost {
      hostname = "thor";
      inherit user;
    };
    mimir = mkHost {
      hostname = "mimir";
      inherit user;
    };
    fenrir = mkHost {
      hostname = "fenrir";
      inherit user;
      extraModules = [
        inputs.nixos-hardware.nixosModules.apple-t2
      ];
    };
  };
}
