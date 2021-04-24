{ pkgs ? import <nokxpkgs> { }, clangSupport ? true, cudaSupport ? false }:

with pkgs;

let
  packageOverrides = python-self: python-super: {
    golden_binding = python-super.golden_binding.overrideAttrs (oldAttrs: rec {
      src = ./.; # pkgs.nix-gitignore.gitignoreSource [ ".git" ]
    });
    dev = python-self.golden_binding.overrideAttrs (oldAttrs: rec {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs
        ++ (with python-self; [ ]);
      propagatedNativeBuildInputs = (with python-self; [
        ipython
        pytest
        sphinx
        sphinx_rtd_theme
        nbformat
        nbconvert
        pandoc
        nbsphinx
        mypy
        pylint
        flake8
        # yapf
        black
      ]);
      nativeBuildInputs = oldAttrs.propagatedBuildInputs
        ++ [ gnumake cmake cmakeCurses ninja clang-tools black ];
      CC = if clangSupport then "clang" else "gcc";
      CXX = if clangSupport then "clang" else "gcc";
      shellHook = ''
        export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
        export PYTHONPATH=$PWD:$PYTHONPATH
      '';
    });

  };

  python3 = pkgs.python3.override (old: {
    packageOverrides =
      stdenv.lib.composeExtensions (old.packageOverrides or (_: _: { }))
      packageOverrides;
  });
  python3Packages = python3.pkgs;
  dev = python3Packages.dev;

in { inherit dev python3 python3Packages; }

