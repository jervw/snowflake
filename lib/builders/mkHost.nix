{
  self,
  inputs,
}: {
  hostname,
  user,
  extraModules ? [],
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  namespace = "snowflake";

  moduleLib = import "${self}/lib/module" {inherit (inputs.nixpkgs) lib;};

  lib = inputs.nixpkgs.lib.extend (_final: _prev: {
    ${namespace} = moduleLib;
  });

  customModules = [
    "${self}/modules"
  ];

  specialArgs = {
    inherit inputs self namespace user lib;
  };
in
  nixosSystem {
    inherit specialArgs;
    modules =
      customModules
      ++ [
        {networking.hostName = hostname;}
        "${self}/hosts/${hostname}"
      ]
      ++ extraModules;
  }
