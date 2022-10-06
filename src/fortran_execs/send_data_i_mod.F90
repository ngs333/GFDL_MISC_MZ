!! *** THIS FILE WAS AUTO-GENERATED FROM FILE: ***
!! *** input_file.F90 .
MODULE send_data_i_mod

   interface send_data
      module procedure send_data_i
   end interface

   private :: send_data_i

   contains

   subroutine send_data_i (x, y, z)
      INTEGER,  dimension(:), intent(in) :: x,y
      INTEGER,  dimension(:), intent(inout) :: z
      REAL :: weight
      weight = 1.0
      z = ( x + y ) ** 2
      PRINT *, "returning from send_data_i"
   end subroutine send_data_i
end module send_data_i_mod
