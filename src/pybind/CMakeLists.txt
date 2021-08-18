# BUILD
pybind11_add_module(pyview pybind_view/wrapper_view.cpp)

# # BUILD WITHOUT CMAKE PYBIND11 MACROS message(STATUS "fancy pybind linking")
# find_package(PythonInterp 3) find_package(PythonLibs 3) add_library(pyview
# MODULE pybind_view/wrapper_view.cpp) target_link_libraries(pyview
# ${PYTHON_LIBRARIES}) set_target_properties(pyview PROPERTIES OUTPUT_NAME
# "pyview" PREFIX "") target_include_directories(pyview PRIVATE
# ${PYTHON_INCLUDE_DIRS}) # BUILD WITHOUT CMAKE PYBIND11 MACROS

# * INSTALLATION
install(TARGETS pyview DESTINATION bin)
