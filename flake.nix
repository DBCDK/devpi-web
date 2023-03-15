
{
  description = "devpi-server with the devpi-web plugin.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }:
    {
      overlays.default = final: prev: {
       devpi-web = (final.python3Packages.callPackage ./devpi-web-package {
          # break loop by using unaltered (super) devpi-server
          devpi-server = prev.devpi-server;
        });

        devpi-server = prev.devpi-server.overrideAttrs (oa: {
          propagatedBuildInputs = oa.propagatedBuildInputs ++ [ final.devpi-web ];
        });
       
        meta = with final.lib; {
          license = licenses.mit;
          maintainers = [ "jozi" ];
          homepage = "https://github.com/DBCDK/devpi-web";
      };
    };
  };
}
