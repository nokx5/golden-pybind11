import pyview
import numpy as np


def dummy():
    a = np.array([1, 2, 3, 4, 5])
    a = np.array([1, 2, 3, 4, 5])
    return pyview.view_nocopy(a)


dummy()
