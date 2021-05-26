from setuptools import setup

# Available at setup time due to pyproject.toml
from pybind11.setup_helpers import Pybind11Extension, build_ext
from pybind11 import get_cmake_dir

import sys
__version__ = "0.0.0"

# The main interface is through Pybind11Extension.
# * You can add cxx_std=11/14/17, and then build_ext can be removed.
# * You can set include_pybind11=false to add the include directory yourself,
#   say from a submodule.
#
# Note:
#   Sort input source files if you glob sources to ensure bit-for-bit
#   reproducible builds (https://github.com/pybind/python_example/pull/53)

ext_modules = [
    Pybind11Extension(
        "python_example",
        ["src/pybind_view/wrapper_view.cpp"],
        # Example: passing in the version to the compiled code
        define_macros=[("PROJECT_VERSION", __version__)],
    ),
]

setup(
    name="golden_binding",
    version=__version__,
    author="nokx",
    author_email="info@nokx.ch",
    license="MIT",
    url="https://nokx5.github.io/golden_binding",
    description="Golden project using pybind11 (C++/Python)",
    ext_modules=ext_modules,
    extras_require={"test": "pytest"},
    cmdclass={"build_ext": build_ext},
    zip_safe=False,
)
