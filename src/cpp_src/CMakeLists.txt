
#possible g++ compilation:
# g++ -std=c++20 -D_GLIBCXX_PARALLEL -march=native -fopenmp -O3  par_sqrt.cpp
# use -ltbb 

add_executable(restarts_fcom_gen.x restarts_fcom_gen.cpp)

target_link_libraries(restarts_fcom_gen.x netcdf-cxx4)

add_executable(fv3_regll_gen.x fv3_regll_gen.cpp)

target_link_libraries(fv3_regll_gen.x netcdf-cxx4)

add_executable(pass_array.x pass_array.C)

add_executable(stdpartest.x stdpartest.C)

add_executable(parsqrttest.x par_sqrt.cpp)

add_executable(par_trans.x par_trans.cpp)


# With both GCC (?) and Intel, require the TBB (for parallel C++17 algorithms).
#On debian, installed via "sudo apt install libtbb-dev"
target_link_libraries(stdpartest.x tbb)
target_link_libraries(parsqrttest.x tbb)
target_link_libraries(par_trans.x tbb)







