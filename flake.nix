{
  description = "A simple pybind11 flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forCustomSystems = custom: f: nixpkgs.lib.genAttrs custom (system: f system);
      allSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
      devSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = forCustomSystems allSystems;
      forDevSystems = forCustomSystems devSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ self.overlay ];
        }
      );

      repoName = "golden-pybind11";
      repoVersion = nixpkgsFor.x86_64-linux.python3Packages.golden-pybind11.version;
      repoDescription = "golden-pybind11 - A simple pybind11 flake";
    in
    {
      overlay = final: prev:
        let
          inherit (prev.lib) composeExtensions;
          pythonPackageOverrides = python-self: python-super: {
            golden-pybind11 = python-self.callPackage ./derivation.nix {
              src = self;
              stdenv = if prev.stdenv.hostPlatform.isDarwin then final.clangStdenv else final.gccStdenv;
            };
            golden-pybind11-clang = python-self.callPackage ./derivation.nix {
              src = self;
              stdenv = final.clangStdenv;
            };
            # project_setuptools =
            #   python-self.callPackage ./derivation-setuptools.nix {
            #     src = self;
            #   };
          };
        in
        {
          python37 = prev.python37.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python38 = prev.python38.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python39 = prev.python39.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python3 = final.python39;
        };

      devShell = forDevSystems (system:
        let pkgs = nixpkgsFor.${system}; in pkgs.callPackage ./shell.nix { clangSupport = false; }
      );

      hydraJobs = {
        build = forDevSystems (system: nixpkgsFor.${system}.python3Packages.golden-pybind11);
        build-clang = forDevSystems (system: nixpkgsFor.${system}.python3Packages.golden-pybind11-clang);

        release = forDevSystems (system:
          with nixpkgsFor.${system}; releaseTools.aggregate
            {
              name = "${repoName}-release-${repoVersion}";
              constituents =
                [
                  self.hydraJobs.build.${system}
                  self.hydraJobs.build-clang.${system}
                  #self.hydraJobs.docker.${system}
                ] ++ lib.optionals (hostPlatform.isLinux) [
                  #self.hydraJobs.deb.x86_64-linux
                  #self.hydraJobs.rpm.x86_64-linux
                  #self.hydraJobs.coverage.x86_64-linux
                ];
              meta.description = "hydraJobs: ${repoDescription}";
            });
      };
      packages = forAllSystems (system:
        with nixpkgsFor.${system}; {
          inherit (python3Packages) golden-pybind11 golden-pybind11-clang;
        });

      defaultPackage = forAllSystems (system:
        self.packages.${system}.golden-pybind11);

      apps = forAllSystems (system: {
        golden-pybind11 = {
          type = "app";
          program = "${self.packages.${system}.golden-pybind11}/bin/cli_golden";
        };
        golden-pybind11-clang = {
          type = "app";
          program = "${self.packages.${system}.golden-pybind11-clang}/bin/cli_golden";
        };
      }
      );

      defaultApp = forAllSystems (system: self.apps.${system}.golden-pybind11);

      templates = {
        golden-pybind11 = {
          description = "template - ${repoDescription}";
          path = ./.;
        };
      };

      defaultTemplate = self.templates.golden-pybind11;
    };
}
