cmake_minimum_required(VERSION 3.18)

# Define the CMake project
project(gfdl_misc
  LANGUAGES CXX C Fortran)

include(GNUInstallDirs)

# The FMS lib is external to this project.
# Indicate here where they are.
include_directories(/home/mzuniga/NetCdCPP/include)
link_directories(/home/mzuniga/NetCdCPP/lib)


# Build options
option(OPENMP    "Build with OpenMP support" ON)

message ("*** CMAKE_Fortran_COMPILER_ID : " ${CMAKE_Fortran_COMPILER_ID})



if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
    set(dialect "-ffree-form -fimplicit-none -ffree-line-length-none")
    set(bounds " -fbounds-check ")
endif()
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Intel")
    set(dialect "-stand f08 -free -implicitnone")
    set(bounds "-check bounds")
endif()

IF( NOT CMAKE_BUILD_TYPE )
   SET( CMAKE_BUILD_TYPE Debug )
ENDIF()

message("*** CMAKE_Fortran_FLAGS : ${CMAKE_Fortran_FLAGS}")
message("*** CMAKE_Fortran_FLAGS_DEBUG : ${CMAKE_Fortran_FLAGS_DEBUG}")
message("*** CMAKE_Fortran_FLAGS_RELEASE : ${CMAKE_Fortran_FLAGS_RELEASE}")

set(CMAKE_Fortran_FLAGS_DEBUG " ${dialect} ${bounds} -g -O0")
set(CMAKE_Fortran_FLAGS_RELASE "${dialect} ${bounds} -g -O2")

set(CMAKE_Fortran_PREPROCESS ON)

message("CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/include")
set(CMAKE_Fortran_MODULE_DIRECTORY ${moduleDir})
message("**CMAKE_Fortran_MODULE_DIRECTORY : ${CMAKE_Fortran_MODULE_DIRECTORY}")


# MPI Find dependencies
#find_package(MPI REQUIRED COMPONENTS C Fortran)
find_package(MPI REQUIRED)
include_directories(${MPI_Fortran_INCLUDE_PATH})
link_directories(${MPI_Fortran_LIBRARIES})

#include_directories(${MPI_INCLUDE_PATH})
#link_directories(${MPI_LIBRARY_DIRS})


#find_package(NetCDF REQUIRED COMPONENTS C Fortran)


# Check for the OpenMP library and set the required compile flags
if (OPENMP)
  find_package(OpenMP REQUIRED COMPONENTS C Fortran)
endif()




set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")

add_subdirectory(cpp_execs)
add_subdirectory(fortran_execs)

#add_dependencies(fve_regll_gen.x FDS)



