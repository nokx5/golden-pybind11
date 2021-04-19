#!/usr/bin/env python
"""The setup and build script for the golden library."""

import codecs
import os
import sys

from setuptools import setup, find_packages


def requirements():
    """Build the requirements list for this project"""
    requirements_list = []

    with open("requirements.txt") as requirements:
        for install in requirements:
            requirements_list.append(install.strip())

    return requirements_list


# packages = find_packages(exclude=["tests*"])
requirements = requirements()

# with codecs.open("README.rst", "r", "utf-8") as fd:
#     fn = os.path.join("golden", "version.py")
#     with open(fn) as fh:
#         code = compile(fh.read(), fn, "exec")
#         exec(code)

setup(
    name="golden_binding",
    version=__version__,
    author="Noam Kestin",
    author_email="info@nokx.ch",
    # license="MIT",
    # url="https://nokx.org/golden-project-python",
    keywords="c++ and python golden project skeleton",
    description="Golden project in hybrid c++ and python",
    # long_description=fd.read(),
    packages=packages,
    # package_data={"golden": ["py.typed"]},
    install_requires=requirements,
    extras_require={"json": "ujson"},
    # include_package_data=True,
    # classifiers=[
    #     "Development Status :: 5 - Production/Stable",
    #     "Intended Audience :: Developers",
    #     "License :: OSI Approved :: MIT License",
    #     "Operating System :: OS Independent",
    #     "Topic :: Software Development :: Libraries :: Python Modules",
    #     "Topic :: Skeleton",
    #     "Programming Language :: Python",
    #     "Programming Language :: Python :: 3",
    #     "Programming Language :: Python :: 3.6",
    #     "Programming Language :: Python :: 3.7",
    #     "Programming Language :: Python :: 3.8",
    #     "Programming Language :: Python :: 3.9",
    # ],
)
