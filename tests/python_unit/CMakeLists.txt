add_test(
  NAME test_python_interface
  COMMAND pytest -vv ${CMAKE_SOURCE_DIR}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
set_tests_properties(
  test_python_interface
  PROPERTIES ENVIRONMENT
             PYTHONPATH=${CMAKE_BINARY_DIR}/src/pybind_view/:$ENV{PYTHONPATH})

# add_custom_target(test_python_interface )
# add_dependencies(test_python_interface pyview)
