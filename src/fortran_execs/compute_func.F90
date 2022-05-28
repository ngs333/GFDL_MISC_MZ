interface compute
   module procedure compute_wp
end interface

private :: compute_wp

contains

subroutine compute_wp (x, y, z)
   real(kind=wp), dimension(:), intent(in) :: x,y
   real(kind=wp), dimension(:), intent(inout) :: z
   z = x + y
end subroutine compute_wp
