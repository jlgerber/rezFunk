#
# RezBuildRust.cmake
#
# usage:
#
# In your root Cmakelists.txt file, set the path to this file in the
#
# CMAKE_MODULE_PATH, using the list command:
#     list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
#
# Then import RezBuildRust using include:
#     include(RezBuildRust)
#
# Now you may call build_rust(...)

# prepend a path onto a list of files. At least that is the intended use. In
# actuallity, the function prepends NEWPATH to each value in SOURCE_FILES,
# updating the array.
FUNCTION( update_path NEWPATH SOURCE_FILES )
    FOREACH( SOURCE_FILE ${${SOURCE_FILES}} )
        SET( MODIFIED ${MODIFIED} ${NEWPATH}/${SOURCE_FILE} )
    ENDFOREACH()
    SET( ${SOURCE_FILES} ${MODIFIED} PARENT_SCOPE )
ENDFUNCTION()

# build_rust Function
#
# calling example
# build_rust(EXECUTABLES rusttest rusttest2)
FUNCTION( build_rust)
    set(EXECS ${ARGN})
    #EXECS
    if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
        set(MODE "release")
    else(${CMAKE_BUILD_TYPE} STREQUAL "Release")
        set(MODE "debug")
    endif()

    message("CMAKE_BUILD_TYPE " ${CMAKE_BUILD_TYPE})
    message("EXECS " ${EXECS})
    # here is the full path to the executable
    set(source_file_path target/${MODE})
    update_path( ${source_file_path} EXECS)

    # set path to sentinel used to determine if build has run
    SET(sentinel ${PROJECT_SOURCE_DIR}/target/.rust_build_sentinel)

    message("REMOVING " ${sentinel} " BEFORE BUILDING TO ENSURE WE EXECUTE cargo build ONCE")
    # remove the sentinel so that we will invoke cargo build
    file(REMOVE ${sentinel})

    # add a custom target which depends upon the sentinel file existing
    add_custom_target(
        custom_cargo_build_target ALL
        DEPENDS ${sentinel}
    )

    # tell cmake that our custom command is responsible for outputing the sentinel file.
    # thus we establish a dependency between custom_Cargo_build_target and this custom command.
    if(${MODE} STREQUAL "release")
        add_custom_command(
            OUTPUT
                ${sentinel}  # fake! ensure we run!
            COMMAND
                $ENV{HOME}/.cargo/bin/cargo build --release
            COMMAND
                touch ${sentinel}
            WORKING_DIRECTORY
                ${PROJECT_SOURCE_DIR}
            COMMENT "RUNNING cargo build --release"
        )
    else(${MODE} STREQUAL "release")
        add_custom_command(
            OUTPUT
                ${sentinel}  # fake! ensure we run!
            COMMAND
                $ENV{HOME}/.cargo/bin/cargo build
            COMMAND
                touch ${sentinel}
            WORKING_DIRECTORY
                ${PROJECT_SOURCE_DIR}
            COMMENT "RUNNING cargo build"
        )
    endif()

    rez_install_files(
        ${EXECS}
        RELATIVE ${source_file_path}
        DESTINATION ./bin
        EXECUTABLE
    )
ENDFUNCTION()