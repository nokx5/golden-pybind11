
golden_binding
==============

This is a skeleton for cpp/python binding project template (called a golden project).

> Development tools used are
> * nix
> * clang-format, black (formatting)
> * vscode (IDE - it exists in nix!) with
    - ms-vscode.cmake-tools
    - ms-vscode.cpptools
    - ms-python.vscode-pylance
    - ms-python.python
    - njpwerner.autodocstring (pydoc)
    - littlefoxteam.vscode-python-test-adapter (pytest)
    - lextudio.restructuredtext (sphinx)
> * ctest (test)
> * sphinx (doc)



develop using nix
=================
Enter the nix shell with
> # nix-shell -I nixpkgs=https://nixos.org/channels/nixpkgs-unstable --pure default.shell.nix
# clang environment
> nix-shell --pure default.shell.nix --argstr clangSupport true
# gcc environment
> nix-shell --pure default.shell.nix

=================
Table of contents
=================

- `Introduction`_

- `Installing`_

- `Getting Started`_

- `Documentation`_
  
- `License`_

============
Introduction
============

==========
Installing
==========

You can install or upgrade with:

.. code:: shell

    $ pip install golden_binding --upgrade

Or you can install from source with:

.. code:: shell

    $ git clone https://github.com/nokx5/golden_binding --recursive
    $ cd golden_binding
    $ python setup.py install
    
In case you have a previously cloned local repository already, you should initialize the added urllib3 submodule before installing with:

.. code:: shell

    $ git submodule update --init --recursive

===============
Getting started
===============

Our Wiki contains a lot of resources to get you started with ``golden_binding``:

- `Introduction to pybind11 <>`_
- Tutorial: `Usage of golden_binding <>`_

Other references:

- `pybind11 API documentation <>`_
- `golden_binding documentation <>`_

=============
Documentation
=============

The ``golden_binding`` documentation uses sphinx.

=======
License
=======

You may copy, distribute and modify the software provided that
modifications are described and licensed for free under the `MIT
<https://opensource.org/licenses/MIT>`_.
