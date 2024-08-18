{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      caddy-custom = pkgs.callPackage ./caddy-custom {
        plugins = [
          "github.com/caddy-dns/cloudflare"
        ];
      };
      cider2 = pkgs.callPackage ./cider2 {};
    };
  };
}
