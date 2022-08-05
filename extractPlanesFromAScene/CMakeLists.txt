#This is mandatory for cmake, and since we are making a very basic project we don’t need features from cmake 3.1 or higher.
cmake_minimum_required(VERSION 3.0)

# set the project name
project(extractPlanesFromScene)
IF(NOT CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE Release
       CACHE STRING "Choose the type of build : None Debug Release"
       FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)
set(CMAKE_CXX_FLAGS "-fpermissive")
#message("* Current build type is : ${CMAKE_BUILD_TYPE}")


#We are requesting to find Ransac package and the PCL package at minimum version 1.3. We
#also say that it is REQUIRED meaning #that cmake will fail #gracefully if it can’t be found.

find_package(Ransac REQUIRED)
find_package(PCL 1.3 REQUIRED)

#To let cmake know about external headers you include in your project, one needs to use include_directories() macro.
include_directories(${RANSAC_INCLUDE_DIRS})
include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

#Here, we tell cmake that we are trying to make an executable file named extractPlanes from one single
#source file extractPlanes.cpp. CMake will take care of the suffix (.exe on Windows platform and blank on UNIX) and the permissions.
add_executable(extractPlanesFromScene extractPlanesFromScene.cpp ${RANSAC_INCLUDE_DIRS})

#We need also to make the linker know about the libraries we are linking against. As said before, the PCL found libraries 
#are referred to using PCL_LIBRARIES variable, all that remains is to trigger the link operation which we do calling target_link_libraries() macro

target_link_libraries(extractPlanesFromScene ${RANSAC_LIBRARIES} ${PCL_LIBRARIES})
