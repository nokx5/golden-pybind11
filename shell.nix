{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, clangSupport ? false }:

with pkgs;
assert hostPlatform.isx86_64;

let
  mkCustomShell = mkShell.override { stdenv = if clangSupport then clangStdenv else gccStdenv; };

  vscodeExt = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      eamodio.gitlens
      ms-vscode.cpptools
      ms-python.python
      ms-python.vscode-pylance
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "cmake";
        publisher = "twxs";
        version = "0.0.17";
        sha256 = "CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
      }
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
        name = "restructuredtext";
        publisher = "lextudio";
        version = "135.0.0";
        sha256 = "yjPS9fZ628bfU34DsiUmZkOleRzW6EWY8DUjIU4wp9w=";
      }
      {
        name = "vscode-clangd";
        publisher = "llvm-vs-code-extensions";
        version = "0.1.12";
        sha256 = "WAWDW7Te3oRqRk4f1kjlcmpF91boU7wEnPVOgcLEISE=";
      }
    ];
  };

  pythonEnv = python3.withPackages (ps: with ps;
    [ numpy pybind11 ] ++ [
      #------------#
      # pydevtools #
      #------------#
      black
      flake8
      ipython
      mypy
      pylint
      pytest
      yapf
      #---------------#
      # documentation #
      #---------------#  
      sphinx
      sphinx_rtd_theme
      nbformat
      nbconvert
      nbsphinx
    ] ++ lib.optionals (!isPy39) [ python-language-server ]);

in
mkCustomShell {
  buildInputs = [ boost17x tbb ] ++ [ pythonEnv ];

  nativeBuildInputs = [ cmake gnumake ninja ] ++ [
    bashCompletion
    bashInteractive
    cacert
    clang-tools
    cmake-format
    cmakeCurses
    cppcheck
    emacs-nox
    fmt
    gdb
    git
    less
    llvm
    more
    nixpkgs-fmt
    pkg-config
  ] ++ lib.optionals (hostPlatform.isLinux) [ typora vscodeExt ] ++ [ black pythonEnv sphinx yapf ];

  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';
}
