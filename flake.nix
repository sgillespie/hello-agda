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
        packages =
          let
            mkAgdaPackage = attrs:
              with pkgs; agdaPackages.mkDerivation ({
                version = "0.0.1";
                pname = "hello-agda";
                buildInputs = [ pkgs.agdaPackages.standard-library ];
                src = ./.;

                meta = {
                  description = "Nix recipe for a minimal agda library";
                  homepage = "https://github.com/sgillespie/hello-agda";
                  platforms = pkgs.lib.platforms.unix;
                  license = pkgs.lib.licenses.mit;
                  maintainers = [{
                    name = "Sean Gillespie";
                    github = "sgillespie";
                    githubId = 139144;
                  }];
                };
              } // attrs);
          in rec {
            lib = mkAgdaPackage {
              # We don't want to output the executable files
              postInstall = ''
                rm -r $out/app
              '';
            };

            app = mkAgdaPackage {
              pname = "hello-agda-exe";

              # Build the application exe
              buildPhase = ''
                cd app
                agda --compile "hello-world.agda"
              '';

              # Copy it to the output dir
              installPhase = ''
                mkdir -p $out/bin
                cp hello-world $out/bin/
              '';
            };

            # We'll usually want to build the exe
            default = app;
          };

        devShells.default = pkgs.mkShell {
          packages = [
            agda
          ];
        };
      });
}
