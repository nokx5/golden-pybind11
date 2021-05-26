{
  description = "A simple C++/Python Binding flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlay = pkgs-self: pkgs-super:
          let
            inherit (pkgs-super.lib) composeExtensions;
            pythonPackageOverrides = python-self: python-super: {
              project_gcc = python-self.callPackage ./derivation.nix {
                src = self;
                stdenv = pkgs-self.gccStdenv;
              };
              project_clang = python-self.callPackage ./derivation.nix {
                src = self;
                stdenv = pkgs-self.clangStdenv;
              };
              project_dev = python-self.callPackage ./derivation-shell.nix { };
            };
          in {
            python37 = pkgs-super.python37.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python38 = pkgs-super.python38.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python39 = pkgs-super.python39.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python3 = pkgs-self.python38;
          };

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ overlay ];
        };
      in {
        packages = {
          golden_binding = pkgs.python3Packages.project_gcc;
          golden_binding_clang = pkgs.python3Packages.project_clang;
        };
        defaultPackage = self.packages.${system}.golden_binding;
        devShell = pkgs.python3Packages.project_dev;
      });
}
