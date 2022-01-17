cmake_minimum_required (VERSION 3.16)
project (hello C)

file(GLOB SOURCES
    main.c
)

include_directories(
	include
)

add_executable(hello ${SOURCES})

target_link_libraries(hello
)
