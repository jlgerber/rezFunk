
cmake_minimum_required(VERSION 3.2)

cmake_policy(SET CMP0037 OLD)
include(RezBuild)
set(files cmake/RezBuildRust.cmake)

rez_install_files(
    ${files}
    RELATIVE .
    DESTINATION .
)