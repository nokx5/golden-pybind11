{ stdenv, buildPythonPackage, src, boost, cmake, ninja, numpy, pybind11, pytest
, sphinx, sphinx_rtd_theme }:

buildPythonPackage rec {
  pname = "golden_binding";
  version = "0.0.0";
  format = "other";
  inherit src;

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost pybind11 ];
  propagatedBuildInputs = [ numpy ];
  checkInputs = [ pytest ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DPROJECT_TESTS=On"
    "-DPROJECT_SANDBOX=OFF"
  ];
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
  enableParallelChecking = true;

  installPhase = "ninja install";

  excludedTests = [ "test_python_interface" ];
  installCheckPhase = ''
    runHook preCheck
    ctest -V -E "${builtins.concatStringsSep "|" excludedTests}"
    export PYTHONPATH=$out/bin:$PYTHONPATH
    python -c "import pyview"
    pytest $src/tests/python -p no:cacheprovider
    runHook postCheck
  '';
}
