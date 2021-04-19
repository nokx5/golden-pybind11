from distutils.core import setup
from golden.version import __version__

import sys

if sys.version_info < (3, 0):
    sys.exit("Sorry, Python < 3.0 is not supported")

setup(
    name="cmake_cpp_pybind11",
    version=__version__,
    packages=["pyview"],
    package_dir={"": "${CMAKE_CURRENT_BINARY_DIR}"},
    package_data={"": ["pyview*.so"]},
)
