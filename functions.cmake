function(target_common_settings target)
    target_compile_features(${target} PUBLIC cxx_std_20)
    target_compile_options(${target} PUBLIC -Werror -Wall -Wextra)
endfunction()

function(add_exe target)
    cmake_parse_arguments(EXE "" "" "LIBS" ${ARGN})
    add_executable(${target} ${EXE_UNPARSED_ARGUMENTS})
    target_common_settings(${target})
    target_link_libraries(${target} PRIVATE ${EXE_LIBS})
endfunction()

function(add_lib target)
    cmake_parse_arguments(LIB "" "" "LIBS" ${ARGN})
    add_library(${target} STATIC)
    target_sources(${target} PRIVATE ${LIB_UNPARSED_ARGUMENTS})
    target_common_settings(${target})
    target_link_libraries(${target} PUBLIC ${LIB_LIBS})
endfunction()

function(copy_file2 target dst src)
    set(SRC_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${src})
    set(DST_FILE ${CMAKE_CURRENT_BINARY_DIR}/${dst})
    add_custom_target(${target}
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SRC_FILE} ${DST_FILE}
        DEPENDS ${SRC_FILE}
    )
endfunction()

function(copy_file target file)
    copy_file2(${target} ${file} ${file})
endfunction()

function(copy_dir2 target dst src)
    set(SRC_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${src})
    set(DST_FILE ${CMAKE_CURRENT_BINARY_DIR}/${dst})
    add_custom_target(${target}
        COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${SRC_FILE} ${DST_FILE}
        DEPENDS ${SRC_FILE}
    )
endfunction()

function(copy_dir target file)
    copy_dir2(${target} ${file} ${file})
endfunction()

function(using_doctest dir)
    include(CTest)
    add_subdirectory(${dir})
    include(${dir}/scripts/cmake/doctest.cmake)

    function(add_test target)
        cmake_parse_arguments(TEST "" "" "LIBS" ${ARGN})
        add_executable(${target} ${TEST_UNPARSED_ARGUMENTS})
        target_common_settings(${target})
        target_link_libraries(${target} PRIVATE doctest ${TEST_LIBS})

        # Here `ADD_LABELS` must be provided.
        set(prefix ${target})
        string(APPEND prefix " - test:")
        doctest_discover_tests(${target} TEST_PREFIX ${prefix} ADD_LABELS 1)
    endfunction()
endfunction()
