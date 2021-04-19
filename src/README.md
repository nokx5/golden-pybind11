$ # installer nix!!
$ nix-shell --pure # enter nix-shell
> mkdir -p build
> cd build
> cmake ..
> make
> python
>>> import np_view # cool, pybind marche
>>> import numpy as np
>>> a = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
>>> np_view.view_nocopy(a)
>>> np_view.view_nocopy(a)[2] = -3
>>> a # ah oui!? trop baleze
>>> exit()
> exit
$ rm -rf build