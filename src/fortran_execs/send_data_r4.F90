
   subroutine send_dat_r (x, y, z)
    !!Note :: should not be allocatalble
    !!GENERIC_START
    REAL,  dimension(:), intent(in) :: x,y
    REAL,  dimension(:), intent(inout) :: z
    !!GENERIC_END
    REAL :: weight
    z = ( x + y ) ** 2
    PRINT *, "returning from send_dat_r"
 end subroutine send_dat_r
