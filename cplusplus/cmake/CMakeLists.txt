
SET (CMAKE_CXX_FLAGS "-std=c++98 -pedantic -Wall --expensive-optimizations -O3 -Os")
SET (SOURCES "multi_map.cpp")
SET (HEADERS )
SET(CMAKE_VERBOSE_MAKEFILE on)

PROJECT (Hello)
ADD_EXECUTABLE (Hello ${SOURCES})
ADD_LIBRARY (Hello2 STATIC ${SOURCES})
ADD_LIBRARY (Hello3 SHARED ${SOURCES})

FIND_PACKAGE (boost)
# BOOST_USE(filesystem)
# BOOST_USE(program_options)

# TARGET_LINK_LIBRARIES(foo ${Boost_filesystem_LIBRARY} ${Boost_program_options_LIBRARY})
