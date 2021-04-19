
# message(STATUS "fancy pybind linking")
# find_package(PythonInterp 3)
# find_package(PythonLibs   3)

# add_library(pyview MODULE wrapper_view.cpp)
# target_link_libraries(pyview ${PYTHON_LIBRARIES})
# set_target_properties(pyview PROPERTIES OUTPUT_NAME "pyview" PREFIX "")
# target_include_directories(pyview PRIVATE ${PYTHON_INCLUDE_DIRS})

# install(
#   FILES ${CMAKE_CURRENT_BINARY_DIR}/pyview.so
#   CONFIGURATIONS Release
#   RUNTIME DESTINATION bin)



pybind11_add_module(pyview wrapper_view.cpp)
install(TARGETS pyview DESTINATION bin)

install(TARGETS pyview DESTINATION ${CMAKE_INSTALL_PYTHON_SITE_PACKAGE})

