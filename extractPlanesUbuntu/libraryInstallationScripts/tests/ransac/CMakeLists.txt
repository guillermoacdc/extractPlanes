cmake_minimum_required(VERSION 3.0)

# set the project name and version
project(ransac_test)
IF(NOT CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE Release
       CACHE STRING "Choose the type of build : None Debug Release"
       FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)
set(CMAKE_CXX_FLAGS "-fpermissive")
message("* Current build type is : ${CMAKE_BUILD_TYPE}")

find_package(Ransac REQUIRED)
include_directories(${RANSAC_INCLUDE_DIRS})
add_executable(ransac_test main.cpp ${RANSAC_INCLUDE_DIRS})
target_link_libraries(ransac_test ${RANSAC_LIBRARIES})
