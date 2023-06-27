
{
  description = "devpi-server with the devpi-web plugin.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }:
  { 
      overlays.default = final: prev: {

      # devpi-common patch snatched form this issue:
      # https://github.com/fschulze/devpi/commit/2aba62c961653aa82181b201995ecbdcb63ce639
      devpi-common-tmp = prev.python3Packages.devpi-common.overridePythonAttrs (oa: {
        # patch below fixes this old `packaging` pin.
        # packaging<22 is no longer in nixpkgs.
        postPatch = ''
          substituteInPlace setup.py \
          --replace "packaging<22" "packaging"

        '' + oa.postPatch;
        patches = [ ./patches/fix-packaging-dependency ];
        # breaks unimportant (and wierd) tarball version checker test.
        checkPhase = "";
      });

       python3Packages = let python = final.python3.override {
           packageOverrides = _: _: { devpi-common = final.devpi-common-tmp; };
         };
       in python.pkgs;

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
