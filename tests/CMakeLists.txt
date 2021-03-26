add_executable(test_runner
        test_support/test_runner.cpp)

add_subdirectory(test_support/libs/libauto_test)
target_link_libraries(test_runner
        PRIVATE auto_test)

add_subdirectory(include)
add_subdirectory(src)

target_include_directories(test_runner PRIVATE include)
target_link_libraries(test_runner
        PUBLIC top_level_test_module)
