# Taken from https://github.com/ihmcrobotics/ihmc-open-robotics-software/blob/5f5345ea78f681c1ca815bb1539041b5d0ab54d0/ihmc-sensor-processing/csrc/ransac_schnabel/CMakeLists.txt
cmake_minimum_required(VERSION 3.0)
set(LIB_MAJOR_VERSION "1")
set(LIB_MINOR_VERSION "0")
set(LIB_PATCH_VERSION "0")
set(LIB_VERSION_STRING "${LIB_MAJOR_VERSION}.${LIB_MINOR_VERSION}.${LIB_PATCH_VERSION}")
cmake_policy(SET CMP0048 NEW)
PROJECT(ransac VERSION "${LIB_VERSION_STRING}" LANGUAGES CXX DESCRIPTION "Ransac For Point Cloud Shape")


set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH
  "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR cmake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/cmake/ransac)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH "Installation directory for CMake files")
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()


set(CMAKE_CXX_FLAGS "-fpermissive")
set(CMAKE_BUILD_TYPE "Release")
option(shared "Build Shared Lib" OFF)

include_directories(./)
include_directories(./MiscLib/)
include_directories(
  "${PROJECT_SOURCE_DIR}"
  "${PROJECT_BINARY_DIR}")

FILE(GLOB SRC "./*.cpp")
FILE(GLOB MISC_SRC "./MiscLib/*.cpp")
FILE(GLOB HEADERS_ROOT "./*.h")
FILE(GLOB HEADERS_MISCLIB "./MiscLib/*.h")
FILE(GLOB HEADERS_GFXTL "./GfxTL/*.h")
FILE(GLOB HEADERS_GFXTL2 "./GfxTL/*.hpp")
if(shared)
 add_library(${PROJECT_NAME} SHARED  ${SRC} ${MISC_SRC})
 SET_PROPERTY(TARGET ${PROJECT_NAME} PROPERTY SOVERSION "${LIB_VERSION_STRING}")
 message (STATUS "Build Shared Library")
else()
 add_library(${PROJECT_NAME} STATIC  ${SRC} ${MISC_SRC})
 message (STATUS "Build Static Library")
endif()

export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/RansacTargets.cmake")
export(PACKAGE ${PROJECT_NAME})
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(RansacConfig.cmake.in "${PROJECT_BINARY_DIR}/RansacConfig.cmake" @ONLY)
set(CONF_INCLUDE_DIRS "\${RANSAC_CMAKE_DIR}/${REL_INCLUDE_DIR}" "\${RANSAC_CMAKE_DIR}/${REL_INCLUDE_DIR}/ransac/")
configure_file(RansacConfig.cmake.in "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/RansacConfig.cmake" @ONLY)
configure_file(RansacConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/RansacConfigVersion.cmake" @ONLY)
install(FILES "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/RansacConfig.cmake" "${PROJECT_BINARY_DIR}/RansacConfigVersion.cmake" DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

configure_file(ransac.pc.in ransac.pc @ONLY)
install(TARGETS ${PROJECT_NAME} DESTINATION ${INSTALL_LIB_DIR}/ EXPORT RansacTargets)
install(FILES ${HEADERS_ROOT} DESTINATION ${INSTALL_INCLUDE_DIR}/${PROJECT_NAME})
install(FILES ${HEADERS_MISCLIB} DESTINATION ${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}/MiscLib)
install(FILES ${HEADERS_GFXTL} DESTINATION ${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}/GfxTL)
install(FILES ${HEADERS_GFXTL2} DESTINATION ${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}/GfxTL)
install(FILES ${CMAKE_BINARY_DIR}/ransac.pc DESTINATION ${INSTALL_LIB_DIR}/pkgconfig)

install(EXPORT RansacTargets DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

