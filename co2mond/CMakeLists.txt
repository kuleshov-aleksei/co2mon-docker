project(co2mond)
cmake_minimum_required(VERSION 3.24.0)

set(HIDAPI_INCLUDE_DIRS
/dependencies/hidapi/include/hidapi
)

set(HIDAPI_LIBRARIES
    /dependencies/hidapi/lib/libhidapi-libusb.so
    /dependencies/hidapi/lib/libhidapi-hidraw.so
)

set(HIDAPI_LIBRARY_DIRS
    /dependencies/hidapi/lib
)

include_directories(
    ../libco2mon/include
    ${HIDAPI_INCLUDE_DIRS})

link_directories(${HIDAPI_LIBRARY_DIRS})

aux_source_directory(src SRC_LIST)
add_executable(co2mond ${SRC_LIST})
target_link_libraries(co2mond
    co2mon
    pthread
    ${HIDAPI_LIBRARIES})

install(TARGETS co2mond
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
