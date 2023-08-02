
#possible g++ compilation:
# g++ -std=c++20 -D_GLIBCXX_PARALLEL -march=native -fopenmp -O3  par_sqrt.cpp
# use -ltbb 


##if (NOT CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
# including the format file if compiler is not gcc. 
# nvc++ does not yet have this feature.
# Intel/CodePlay DPC++ has ?
include_directories(${CMAKE_SOURCE_DIR}/cpp_src)
include_directories(${CMAKE_SOURCE_DIR}/cpp_src/include)
##endif()
add_executable(restarts_fcom_gen.x restarts_fcom_gen.cpp)

target_link_libraries(restarts_fcom_gen.x netcdf-cxx4)

add_executable(fv3_regll_gen.x fv3_regll_gen.cpp)

target_link_libraries(fv3_regll_gen.x netcdf-cxx4)

add_executable(pass_array.x pass_array.C)

add_executable(stdpartest.x stdpartest.C)
add_executable(parsqrttest.x par_sqrt.cpp)
add_executable(par_trans.x par_trans.cpp)
add_executable (test_mdspan.x test_mdspan.C)

# With both GCC (?) and Intel, require the TBB (for parallel C++17 algorithms).
#On debian, installed via "sudo apt install libtbb-dev"
target_link_libraries(stdpartest.x tbb) ## nvc++ vs gcc (used tbb) ?
target_link_libraries(parsqrttest.x tbb)
target_link_libraries(par_trans.x tbb)
target_link_libraries(test_mdspan.x tbb)

##target_include_directories(stdpartest.x  INTERFACE ${CMAKE_SOURCE_DIR}/cpp_src)

##add_subdirectory(common)








