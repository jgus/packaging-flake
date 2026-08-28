{
  description = "packaging: Python package versioned independently from nixpkgs.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-lib = {
      url = "github:jgus/flake-lib/v1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, flake-lib, ... }:
    let
      source = { type = "pypi"; pname = "packaging"; format = "sdist"; };
      package = {
        attr = "packaging";
        description = "Core utilities for Python packages";
        buildSystem = ps: [ ps.flit-core ];
      };
      pin = import ./pin.nix;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          packaging = flake-lib.lib.mkPypiPackage { inherit pkgs source package pin; };
        in
        {
          packages = {
            inherit packaging;
            default = packaging;
            update-version = flake-lib.lib.mkUpdateVersion {
              inherit pkgs source;
              buildAttr = "packaging";
            };
            update-branches = flake-lib.lib.mkUpdateBranches {
              inherit pkgs source;
              pinSchema = "pypi";
              minVersionComponents = 2;
            };
          };
        });
}
