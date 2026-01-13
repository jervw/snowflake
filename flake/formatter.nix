{
  perSystem = {config, ...}: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        statix.enable = true;
        deadnix.enable = true;
        mdformat.enable = true;
        yamlfmt.enable = true;
      };
    };
    formatter = config.treefmt.build.wrapper;
  };
}
