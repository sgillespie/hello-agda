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
        devShells.default = pkgs.mkShell {
          packages = [
            agda
          ];
        };
      });
}
