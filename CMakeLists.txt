cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)

set(PROJECT_VERSION "0.0.0")

project(
  golden-pybind11
  LANGUAGES C CXX
  VERSION "${PROJECT_VERSION}"
  DESCRIPTION "Hybrid C++/Python Golden Project")

set(CMAKE_C_COMPILER $ENV{CC})
set(CMAKE_CXX_COMPILER $ENV{CXX})

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMake)

# ##############################################################################
# OPTIONS
# ##############################################################################

option(PROJECT_BENCHMARK "Compile the performance in ctest" OFF)
option(PROJECT_INTEGRATION "Compile the integration tests in ctest" OFF)
option(PROJECT_MEMCHECK "Enable memcheck test with valgrind" OFF)
option(PROJECT_PYTHON "Build Python Wrapper (pybind)" ON)
option(PROJECT_UNIT_TESTS "Compile the unit tests in ctest" ON)
option(PROJECT_SANDBOX "Compile the sandbox folder" OFF)
option(PROJECT_STATIC "Build Static Libraries" OFF)
option(PROJECT_TBBMALLOC_PROXY
       "enable tbb_malloc_proxy linking (conflicts with pybind)" OFF)

# ##############################################################################
# FLAGS
# ##############################################################################

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_options(-Wall -Wextra)
# #
# https://stackoverflow.com/questions/45955272/modern-way-to-set-compiler-flags-in-cross-platform-cmake-project
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND APPLE)
  add_compile_options("-Wa" "-q")
else()
  # TODO
endif()

# ##############################################################################
# FIND PACKAGES
# ##############################################################################
# * Boost
find_package(
  Boost REQUIRED
  COMPONENTS filesystem system program_options unit_test_framework
  REQUIRED)
include_directories(SYSTEM ${Boost_INCLUDE_DIR})

mark_as_advanced(
  Boost_SYSTEM_LIBRARY_RELEASE Boost_FILESYSTEM_LIBRARY_RELEASE
  Boost_PROGRAM_OPTIONS_LIBRARY_RELEASE
  Boost_UNIT_TEST_FRAMEWORK_LIBRARY_RELEASE)

# * TBB
if(${PROJECT_TBBMALLOC_PROXY})
  find_package(TBB REQUIRED tbb tbbmalloc_proxy)
else()
  find_package(TBB REQUIRED tbb)
endif()

if(${PROJECT_PYTHON})
  # * Pybind11
  find_package(
    Python
    COMPONENTS Interpreter Development
    REQUIRED)
  find_package(pybind11 CONFIG REQUIRED)
  # python install prefix
  if(NOT DEFINED CMAKE_INSTALL_PYTHON_SITE_PACKAGE)
    set(CMAKE_INSTALL_PYTHON_SITE_PACKAGE
        "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages/"
    )
  endif()
endif()

# ##############################################################################
# INCLUDE
# ##############################################################################
configure_file("${CMAKE_SOURCE_DIR}/src/utils/static.hpp.in"
               "${CMAKE_BINARY_DIR}/static.hpp")
include_directories("${CMAKE_SOURCE_DIR}/src" ${CMAKE_BINARY_DIR})

# ##############################################################################
# PROJECT
# ##############################################################################
add_subdirectory(src/golden)
if(${PROJECT_PYTHON})
  add_subdirectory(src/pybind)
endif()

# ##############################################################################
# TESTS and miscelaneous
# ##############################################################################
include(CTest)
# enable_testing()

if(${PROJECT_UNIT_TESTS})
  add_subdirectory(tests/cpp_unit)
  if(${PROJECT_PYTHON})
    add_subdirectory(tests/python_unit)
  endif()
endif()
if(${PROJECT_SANDBOX})
  add_subdirectory(tests/sandbox)
endif()
if(${PROJECT_BENCHMARK})
  add_subdirectory(tests/cpp_benchmark)
endif()
if(${PROJECT_INTEGRATION})
  add_subdirectory(tests/cpp_integration)
endif()
