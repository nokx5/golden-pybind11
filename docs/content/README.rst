.. _golden binding: https://nokx5.github.io/golden-pybind11

=========================================
Welcome to the `golden binding`_ template
=========================================
This is a skeleton for a C++/python project template. 
Please find all the documentation `here <https://nokx5.github.io/golden-pybind11>`_ and the source code `there <https://github.com/nokx5/golden-pybind11>`_.

My development tools are
========================

- nix ❄️ (packaging from hell ❤️)

- clang-format (formatter)

- black (formatter)
  
- vscode (IDE) with
  
  - ms-vscode.cmake-tools
  - ms-vscode.cpptools
  - ms-python.vscode-pylance
  - ms-python.python
  - lextudio.restructuredtext

- ctest (tests)

- pytest (tests)

- Sphinx (docs)

Use the classic Nix commands
============================

Use the software (without git clone)
------------------------------------


The `nokxpkgs <https://github.com/nokx5/nokxpkgs#add-nokxpkgs-to-your-nix-channel>`_ channel and associate overlay can be imported with the ``-I`` command or by setting the ``NIX_PATH`` environment variable.

.. code:: shell

    nix-shell -I nixpkgs=https://github.com/nokx5/nokxpkgs/archive/main.tar.gz -p golden-pybind11 --command cli_golden


Develop the software
--------------------

Start by cloning the `git repository <https://github.com/nokx5/golden-pybind11>`_ golden python locally and enter it. 

Option 1: Develop the software (minimal requirements)
.....................................................

You can develop or build the local software easily with the minimal requirements.

.. code:: shell

    # option a: develop with a local shell
    nix-shell --expr '{pkgs ? import <nixpkgs> {} }: with pkgs; with python3Packages; callPackage ./derivation.nix { src = ./.; }'
    
    # option b: build the local project
    nix-build --expr '{pkgs ? import <nixpkgs> {} }: with pkgs; with python3Packages; callPackage ./derivation.nix { src = ./.; }'

Note that you can write the nix expression directly to the ``default.nix`` file to avoid typing ``--expr`` each time.

Option 2: Develop the software (supercharged 🛰️)
................................................

You can enter the supercharged environment for development.

.. code:: shell

    nix-shell derivation-shell.nix


Use the experimental flake feature
==================================

.. warning:: **NOTE:** This section requires the experimental *flake* and *nix-command* features. Please refer to the official documentation for nix flakes. The advantage of using nix flakes is that you avoid channel pinning issues.

After Nix was installed, update to the unstable feature with:

.. code:: shell

    nix-env -f '<nixpkgs>' -iA nixUnstable

And enable experimental features with:

.. code:: shell

    mkdir -p ~/.config/nix
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

Use the software (without git clone)
------------------------------------

.. code:: shell

    nix shell github:nokx5/golden-pybind11 --command cli_golden


Develop the software
--------------------

Start by cloning the `git repository <https://github.com/nokx5/golden-pybind11>`_ locally and enter it. 

Option 1: Develop the software
..............................

.. code:: shell

    # option a: develop with a local shell
    nix develop .#golden-pybind11

    # option b: build the local project
    nix build .#golden-pybind11

Option 2: Develop the software (supercharged 🛰️)
................................................

You can enter the development supercharged environment.

.. code:: shell

    nix develop .#fullDev


Installation with pip
=====================

You can install or upgrade the project with:

.. code:: shell

    pip install golden-pybind11 --upgrade

Or you can install from source with:

.. code:: shell

    python setup.py install

=============
Code Snippets
=============

.. code:: shell

    nixfmt $(find -name "*.nix")

    clang-format -i $(find . -path "./build*" -prune  -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp")

    cmake-format -i $(find . -path "./build*" -prune  -name "*.cmake" -o -name "CMakeLists.txt")

=======
License
=======

You may copy, distribute and modify the software provided that
modifications are described and licensed for free under the `MIT
<https://opensource.org/licenses/MIT>`_.
