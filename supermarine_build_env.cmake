set(PROJECT_SRC ${CMAKE_HOME_DIRECTORY}/src)
set(PROJECT_INCLUDE ${CMAKE_HOME_DIRECTORY}/include)
set(PROJECT_INTERNAL_LIBS ${CMAKE_HOME_DIRECTORY}/libs)

set(SUPERMARINE_MODULE_EXTENSION _module)

function(supermarine_add_internal_library target lib_name)
    target_include_directories(${target}${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${PROJECT_INTERNAL_LIBS}/${lib_name}/include)
endfunction()

function(supermarine_add_internal_library_for_cmake_target target lib_name)
    target_include_directories(${target} PRIVATE ${PROJECT_INTERNAL_LIBS}/${lib_name}/include)
endfunction()

function(supermarine_add_leaf_module module_name)
    file(GLOB_RECURSE module_HEADERS CONFIGURE_DEPENDS "*.hpp")
    file(RELATIVE_PATH module_relative_pos ${PROJECT_INCLUDE} ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB_RECURSE module_SRC CONFIGURE_DEPENDS "${PROJECT_SRC}/${module_relative_pos}/*.cpp")

    add_library(${module_name}${SUPERMARINE_MODULE_EXTENSION} ${module_SRC} ${module_HEADERS})

    target_include_directories(${module_name}${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${PROJECT_INCLUDE})
endfunction()

MACRO(SUBDIRLIST result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${curdir}/${child})
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()
    SET(${result} ${dirlist})
ENDMACRO()

function(supermarine_add_collate_module module_name)
    file(GLOB module_HEADERS CONFIGURE_DEPENDS "*.hpp")
    file(RELATIVE_PATH module_relative_pos ${PROJECT_INCLUDE} ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB module_SRC CONFIGURE_DEPENDS "${PROJECT_SRC}/${module_relative_pos}/*.cpp")

    add_library(${module_name}${SUPERMARINE_MODULE_EXTENSION} ${module_SRC} ${module_HEADERS})

    subdirlist(subDirs ${CMAKE_CURRENT_SOURCE_DIR})
    foreach(subdir ${subDirs})
        add_subdirectory(${subdir})
        target_link_libraries(${module_name}${SUPERMARINE_MODULE_EXTENSION} PUBLIC ${subdir}${SUPERMARINE_MODULE_EXTENSION})
    endforeach()

    target_include_directories(${module_name}${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${PROJECT_INCLUDE})
endfunction()

function(supermarine_add_top_level_src target)
    target_include_directories(${target} PRIVATE ${PROJECT_INCLUDE})
    target_link_libraries(${target} PRIVATE top_level_src_module)
endfunction()

macro(supermarine_project target)
    add_subdirectory(${PROJECT_INCLUDE})
endmacro()

# Test functions
set(PROJECT_TEST_SRC ${CMAKE_HOME_DIRECTORY}/tests/src)
set(PROJECT_TEST_INCLUDE ${CMAKE_HOME_DIRECTORY}/tests/include)
set(PROJECT_TEST_INTERNAL_LIBS ${CMAKE_HOME_DIRECTORY}/tests/libs)

function(supermarine_add_leaf_test_module module_name)
    file(GLOB_RECURSE module_SRC CONFIGURE_DEPENDS "*.cpp")

    add_library(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} ${module_SRC})

    # Add the main code
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/include)
    target_link_libraries(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE top_level_src_module)

    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${PROJECT_TEST_INCLUDE})
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/tests/include)
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/tests/test_support/libs/libauto_test/include)

    target_link_libraries(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE auto_test)
endfunction()

function(supermarine_add_collate_test_module module_name)
    file(GLOB module_SRC CONFIGURE_DEPENDS "*.cpp")

    add_library(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} ${module_SRC})

    # Add the main code
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/include)
    target_link_libraries(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE top_level_src_module)

    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${PROJECT_TEST_INCLUDE})
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/tests/include)
    target_include_directories(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE ${CMAKE_HOME_DIRECTORY}/tests/test_support/libs/libauto_test/include)

    target_link_libraries(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PRIVATE auto_test)

    subdirlist(subDirs ${CMAKE_CURRENT_SOURCE_DIR})
    foreach(subdir ${subDirs})
        add_subdirectory(${subdir})
        target_link_libraries(${module_name}_test${SUPERMARINE_MODULE_EXTENSION} PUBLIC ${subdir}_test${SUPERMARINE_MODULE_EXTENSION})
    endforeach()
endfunction()