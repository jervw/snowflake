{
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      caddy-custom = pkgs.callPackage ./caddy-custom {};
      cider2 = pkgs.callPackage ./cider2 {};
    };
  };
}
