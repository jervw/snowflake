{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      cider = pkgs.callPackage ./cider {};
    };
  };
}
