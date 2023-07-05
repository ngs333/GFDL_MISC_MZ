cmake_minimum_required(VERSION 3.21)

# Define the CMake project
project(gfdl_misc
  LANGUAGES CXX C Fortran)

#NOTE: this will not overrride the arg set in CXXFLAGS for -std
set(CMAKE_CXX_STANDARD 23)

set(CMAKE_VERBOSE_MAKEFILE ON)

include(GNUInstallDirs)

#Location of some libs is external to this project.
include_directories(/home/mzuniga/NetCdCPP/install/include)
link_directories(/home/mzuniga/NetCdCPP/install/lib)


# Build options
option(OPENMP    "Build with OpenMP support" ON)

IF( NOT CMAKE_BUILD_TYPE )
   SET( CMAKE_BUILD_TYPE Debug )
ENDIF()
message("CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

# Some detailed Fortran compiling controls
message ("** CMAKE_Fortran_COMPILER_ID : ${CMAKE_Fortran_COMPILER_ID}")
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
    set(dialect "-ffree-form -fimplicit-none -ffree-line-length-none")
    set(bounds " -fbounds-check ")
endif()
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Intel")
    set(dialect "-stand f08 -free -implicitnone")
    set(bounds "-check bounds")
endif()

set(CMAKE_Fortran_PREPROCESS ON)
set(CMAKE_Fortran_FLAGS_DEBUG " ${dialect} ${bounds} -g -O0")
set(CMAKE_Fortran_FLAGS_RELASE "${dialect} ${bounds} -g -O2")
message("** CMAKE_Fortran_FLAGS_DEBUG : ${CMAKE_Fortran_FLAGS_DEBUG}")
message("***CMAKE_Fortran_FLAGS_RELEASE : ${CMAKE_Fortran_FLAGS_RELEASE}")

set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/include")
set(CMAKE_Fortran_MODULE_DIRECTORY ${moduleDir})
message("** CMAKE_Fortran_MODULE_DIRECTORY : ${CMAKE_Fortran_MODULE_DIRECTORY}")

# info on c++ 
message ("** CMAKE_CXX_COMPILER_ID : ${CMAKE_CXX_COMPILER_ID}")
message ("** CMAKE_CXX_FLAGS :  ${CMAKE_CXX_FLAGS} ")


# MPI Find dependencies
find_package(MPI REQUIRED COMPONENTS C Fortran)
find_package(MPI REQUIRED)
include_directories(${MPI_Fortran_INCLUDE_PATH})
link_directories(${MPI_Fortran_LIBRARIES})
include_directories(${moduleDir})

include_directories(${MPI_INCLUDE_PATH})
link_directories(${MPI_LIBRARY_DIRS})

#if netcdf is providing NetCDFConfig.cmake and netcdf-config.cmake
#find_package(NetCDF REQUIRED COMPONENTS C Fortran)


# Check for the OpenMP library and set the required compile flags
if (OPENMP)
  find_package(OpenMP REQUIRED COMPONENTS C Fortran)
endif()


#compile and install the fortran modules
file( GLOB fortran_mod_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/fortran_src/*_mod.F90 )
add_library( gfdl_misc STATIC ${fortran_mod_SOURCES} )
install( TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/Lib/ )
install(DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})


set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")

add_subdirectory(c_src)
add_subdirectory(cpp_src)
add_subdirectory(fortran_src)

#add_dependencies(fve_regll_gen.x FDS)



