# External modules from inputs that don't have their wrapper modules.
{inputs, ...}: {
  imports = with inputs; [
    agenix.nixosModules.default
    disko.nixosModules.disko
  ];
}
