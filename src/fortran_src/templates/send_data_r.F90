MODULE send_data_r_mod

   interface send_data
      module procedure send_data_r
   end interface

   private :: send_data_r

   contains

   subroutine send_data_r (x, y, z)
      !!Note :: should not be allocatalble
      _REAL_,  dimension(:), intent(in) :: x,y
      _REAL_,  dimension(:), intent(inout) :: z
      REAL :: weight
      weight = 1.0
      z = ( x + y ) ** 2
      PRINT *, "returning from send_data_r"
   end subroutine send_data_r
end module send_data_r_mod
