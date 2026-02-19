{
  description = "Nix packages by RogueOneEcho";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.caesura;
          caesura = pkgs.callPackage ./pkgs/caesura.nix {
            sox-ng = self.packages.${system}.sox-ng;
          };
          sox-ng = pkgs.callPackage ./pkgs/sox-ng.nix { };
        };
      }
    );
}
