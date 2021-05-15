{ pkgs, project_clang, project_gcc }:

let
  clangSupport = false;
  cudaSupport = false;

  stdenv = (with pkgs; if clangSupport then clangStdenv else gccStdenv);
  project = if clangSupport then project_clang else project_gcc;
  pythonPackages = pkgs.python3Packages;

  vscodeExt = (with pkgs;
    vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.Nix
          eamodio.gitlens
          ms-vscode.cpptools
          ms-python.python
          ms-python.vscode-pylance
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "cmake-tools";
            publisher = "ms-vscode";
            version = "1.7.3";
            sha256 = "6UJSJETKHTx1YOvDugQO194m60Rv3UWDS8UXW6aXOko=";
          }
          {
            name = "emacs-mcx";
            publisher = "tuttieee";
            version = "0.31.0";
            sha256 = "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
          }
          {
            name = "cmake";
            publisher = "twxs";
            version = "0.0.17";
            sha256 = "CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
          }
        ];
    });
  pythonEnv = (with pythonPackages; # note that checkInputs are missing!
    (with project; propagatedBuildInputs ++ propagatedNativeBuildInputs) ++ [
      #------------#
      # additional #
      #------------#
      decorator
      pyjson5
      toml
      #------------#
      # pydevtools #
      #------------#
      ipython
      pip
      pytest
      mypy
      pylint
      flake8
      yapf
      black
      #---------------#
      # documentation #
      #---------------#      
      sphinx
      sphinx_rtd_theme
      nbformat
      nbconvert
      nbsphinx
    ]);
in (pkgs.mkShell.override { inherit stdenv; }) rec {
  buildInputs = (with pkgs;
    [
      zlib # stdenv.cc.cc.lib
    ] ++ [ pythonEnv ] ++ project.buildInputs);
  nativeBuildInputs = (with pkgs;
    [
      # stdenv.cc.cc
      # libcxxabi	      
      bashCompletion
      cacert
      clang-tools
      cmake-format
      cmakeCurses
      emacs-nox
      gdb
      git
      gnumake
      nixfmt
      pkg-config
      emacs-nox
      vscodeExt
      pandoc
      typora
      vscodeExt
    ] ++ [ black jupyter pythonEnv sphinx yapf ] ++ project.nativeBuildInputs);
  shellHook = ''
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    export PYTHONPATH=$PWD:$PYTHONPATH
    echo ""
    echo "You may want to import the pybind11 library during development"
    echo "(assuming the project was compiled in ./b*) :"
    echo ""
    echo "export PYTHONPATH=\$(readlink -f \$PWD/b*/src/pybind_* | tr '\\n' ':'):\$PYTHONPATH"
    echo ""
  '';
}
