{
  description = "igraph SE2 implementation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-matlab }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default =
        (pkgs.mkShell.override { stdenv = pkgs.gcc10Stdenv; }) {
          packages = (with nix-matlab.packages.${system}; [
            matlab
            matlab-mlint
            matlab-mex
          ]) ++ (with pkgs; [
            astyle
            cmake
            ninja
            gdb
            # igraph dependencies
            bison
            flex
            libxml2
          ]);
        };
    };
}
