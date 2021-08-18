add_executable(sandbox_exe sandbox.cpp)
# target_link_libraries(sandbox_exe Boost::system Boost::filesystem)
add_test(run_sandbox sandbox_exe)
