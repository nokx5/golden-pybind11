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
              golden-pybind11 = python-self.callPackage ./derivation.nix {
                src = self;
                stdenv = pkgs-self.gccStdenv;
              };
              golden-pybind11-clang = python-self.callPackage ./derivation.nix {
                src = self;
                stdenv = pkgs-self.clangStdenv;
              };
              # project_setuptools =
              #   python-self.callPackage ./derivation-setuptools.nix {
              #     src = self;
              #   };
              fullDev = python-self.callPackage ./shell.nix { };
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
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
      in {
        packages = {
          inherit (pkgs.python3Packages)
            fullDev golden-pybind11 golden-pybind11-clang;
        };
        defaultPackage = self.packages.${system}.golden-pybind11;
        devShell = self.packages.${system}.golden-pybind11;
      });
}
