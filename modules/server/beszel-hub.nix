{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.beszel
  ];

  services.beszel.server = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
