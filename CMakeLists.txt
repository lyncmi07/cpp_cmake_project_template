include(supermarine_build_env.cmake)

cmake_minimum_required(VERSION 3.17)
set(CMAKE_CXX_STANDARD 17)
add_definitions(-DINFO)

project(cpp_cmake_project_template)
supermarine_project(cpp_cmake_project_template)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(hello_world src/executables/hello_world.cpp)

supermarine_add_top_level_src(hello_world)

supermarine_add_internal_library_for_cmake_target(hello_world libcpp_logger)
add_subdirectory(tests)