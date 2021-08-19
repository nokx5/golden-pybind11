{ stdenv
, buildPythonPackage
, src
, boost17x
, cmakeMinimal
, ninja
, numpy
, pybind11
, pytest
, tbb
, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "golden-pybind11";
  version = "0.0.0";
  format = "other";
  inherit src;

  nativeBuildInputs = [ cmakeMinimal ninja ];
  buildInputs = [ boost17x pybind11 tbb ];
  propagatedBuildInputs = [ numpy ];
  checkInputs = [ pytest ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DPROJECT_TESTS=ON"
    "-DPROJECT_SANDBOX=OFF"
  ];
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
  enableParallelChecking = true;

  installPhase = "ninja install";
}
