#include <pybind11/numpy.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
namespace py = pybind11;

template <typename T> using numpy_array = py::array_t<T, py::array::c_style>;

numpy_array<int64_t> view_nocopy(numpy_array<int64_t> np_in) {
  // py::buffer_info np_in_info = np_in.request();
  /* C++ code accessed */
  std::size_t n = np_in.size() - 2;
  auto ptr = np_in.data() + 1;
  // *ptr = 6;
  auto fake_deallocator = py::capsule(ptr, [](void *ptr) {});
  numpy_array<int64_t> np_out(n, ptr, fake_deallocator);
  /* ----------------- */
  return np_out;
}

PYBIND11_MODULE(pyview, m) {
  m.doc() = "a pybind11 example for jeremy <3";
  m.def("view_nocopy", &view_nocopy,
        "A numpy view of int64_t without first and last element");
}
