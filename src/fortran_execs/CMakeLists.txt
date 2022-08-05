file( GLOB fortran_mod_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*_mod.F90 )

add_library( send_dat ${fortran_mod_SOURCES} )

add_executable(test_diag_dlinked_list.x test_diag_dlinked_list.F90 fms_diag_dlinked_list.F90)
add_executable(test_compute2.x test_compute.F90  compute_all.F90 compute_r4.F90 compute_r8.F90)
add_executable(test_send_data.x test_send_data.F90)
add_executable(test_elemental_weighting_procs.x test_elemental_weighting_procs.F90)

target_link_libraries(test_send_data.x send_dat)



