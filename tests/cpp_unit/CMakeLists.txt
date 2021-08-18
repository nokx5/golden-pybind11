set(UNIT_TESTS_NAMES dummy)

foreach(UNIT_TEST_NAME ${UNIT_TESTS_NAMES})
  add_executable(test_${UNIT_TEST_NAME} test_${UNIT_TEST_NAME}.cpp)
  target_compile_definitions(
    test_${UNIT_TEST_NAME} PUBLIC BOOST_TEST_MODULE=${UNIT_TEST_NAME}
                                  BOOST_TEST_DYN_LINK=TRUE)
  target_link_libraries(test_${UNIT_TEST_NAME} Boost::unit_test_framework
                        Boost::system)
  add_test(unit_${UNIT_TEST_NAME} test_${UNIT_TEST_NAME})
endforeach()
