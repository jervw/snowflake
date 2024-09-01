{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    cloudflare.file = "${self}/secrets/cloudflare.age";
  };
}
