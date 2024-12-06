{
  description = "devpi-server with the devpi-web plugin.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # I'm to lazy to change this in deployments
        overlays = [ self.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        packages = rec {
          default = pkgs.devpi-web;
          devpi-web = pkgs.devpi-web;
          devpi-server = pkgs.devpi-server;
        };
      }
    )
    // {
      overlays.default = final: prev: {
        devpi-web = (
          final.python3Packages.callPackage ./devpi-web-package {
            # break loop by using unaltered (super) devpi-server
            devpi-server = prev.devpi-server;
          }
        );

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
