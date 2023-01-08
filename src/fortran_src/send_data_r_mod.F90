!! *** THIS FILE WAS AUTO-GENERATED FROM FILE: ***
!! *** ../fortran_execs/templates/send_data_r.F90 .
MODULE send_data_r_mod

   interface send_data
      module procedure send_data_r
   end interface

   private :: send_data_r

   contains

   subroutine send_data_r (x, y, z)
      !!Note :: should not be allocatalble
      REAL,  dimension(:), intent(in) :: x,y
      REAL,  dimension(:), intent(inout) :: z
      REAL :: weight
      weight = 1.0
      z = ( x + y ) ** 2
      PRINT *, "returning from send_data_r"
   end subroutine send_data_r
end module send_data_r_mod
