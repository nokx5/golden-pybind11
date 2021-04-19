{ pkgs ? import <nixpkgs> { }, clangSupport ? false, cudaSupport ? false }:

with pkgs;

let
  stdenv = if clangSupport then clangStdenv else gccStdenv;
  # python3Packages.override { inherit stdenv; }
  pythonEnv = python3.withPackages (ps:
    with ps; [
      pybind11
      setuptools_scm
      numpy
      pyjson5
      #------------#
      # pydevtools #
      #------------#
      sphinx
      sphinx_rtd_theme
      pytest
      mypy
      pylint
      flake8
      yapf
    ]);

in (mkShell.override { inherit stdenv; }) rec {

  nativeBuildInputs = [ cmake ninja gnumake black ];

  buildInputs = [
      boost
      # blas hdf5
      # tbb
      # eigen
    ] ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;


  propagatedNativeBuildInputs =
    [ pythonEnv ]; # avoid separation of devtools in python

  propagatedBuildInputs = [ pythonEnv ];

  shellHook = ''
    export PATH=/nix/var/nix/profiles/per-user/$USER/tools-dev/bin/:$PATH
    export PYTHONPATH=$PYTHONPATH:$PWD;
    echo ""
    echo "You may want to import the pybind11 library during development"
    echo "(assuming the project was compiled in ./b*) :"
    echo ""
    echo "export PYTHONPATH=\$(readlink -f $PWD/b*/src/pybind_* | tr '\\n' ':'):\$PYTHONPATH"
    echo ""
  '';
}
