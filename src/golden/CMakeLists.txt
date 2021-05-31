set(libraries gold)

foreach(library ${libraries})

  if(${PROJECT_STATIC})
    add_library(${library} STATIC core/${library}.cpp)
  else()
    add_library(${library} SHARED core/${library}.cpp)
  endif()
  target_link_libraries(${library}) # ${BOOST_LIBRARIES} Boost::system
                                    # Boost::filesystem

endforeach()

set(clicommands golden)

foreach(clicommand ${clicommands})

  add_executable(cli_${clicommand} cli/${clicommand}.cpp)
  # target_link_libraries(cli_${clicommand} ${BOOST_LIBRARIES})

  install(
    TARGETS cli_${clicommand}
    CONFIGURATIONS Release
    DESTINATION bin)

endforeach()
