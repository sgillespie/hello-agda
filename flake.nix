{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }@inputs:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        agda = pkgs.agda.withPackages (p: [ p.standard-library ]);
      in {
        packages.default = with pkgs; agdaPackages.mkDerivation {
          version = "0.0.1";
          pname = "hello-agda";
          src = ./.;

          buildInputs = [ agdaPackages.standard-library ];

          meta = {
            description = "Nix recipe for a minimal agda library";
            homepage = "https://github.com/sgillespie/hello-agda";
            platforms = lib.platforms.unix;
            license = lib.licenses.mit;
            maintainers = [{
              name = "Sean Gillespie";
              github = "sgillespie";
              githubId = 139144;
            }];
          };

        };

        devShells.default = pkgs.mkShell {
          packages = [
            agda
          ];
        };
      });
}
