   interface sendf
      module procedure sendf_wp
   end interface 

   private :: sendf_wp

   contains

   subroutine sendf_wp(x, y, z)
      INTEGER(kind=wp),  dimension(:), intent(in) :: x,y
      INTEGER(kind=wp),  dimension(:), intent(inout) :: z
      REAL :: weight
      weight = 1.0
      z = ( x + y ) ** 2
      PRINT *, "returning from sendf_i"
   end subroutine sendf_wp
