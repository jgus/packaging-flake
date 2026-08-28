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
    flake-lib.lib.mkLeafFlake {
      inherit nixpkgs flake-utils;
      source = { type = "pypi"; pname = "packaging"; format = "sdist"; };
      package = {
        attr = "packaging";
        description = "Core utilities for Python packages";
        buildSystem = ps: [ ps.flit-core ];
      };
      pin = import ./pin.nix;
    };
}
