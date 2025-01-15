{
  inputs,
  self,
  ...
}: {
  flake.deploy.nodes = {
    thor = {
      hostname = "thor.myth-gentoo.ts.net";
      sshUser = "root";
      profiles.system = {
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.thor;
      };
    };
  };
}
