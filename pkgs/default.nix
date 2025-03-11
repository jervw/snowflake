{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      cider2 = pkgs.callPackage ./cider2 {};
      beeper-beta = pkgs.callPackage ./beeper-beta {};
    };
  };
}
