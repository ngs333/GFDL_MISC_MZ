program test_send_data

   use send_data_mod

   implicit none

   integer i
   real, allocatable,  dimension(:) :: rxr,ryr,rzr
   class(*), allocatable,  dimension(:) :: xr,yr,zr
   class(*), allocatable, dimension(:) :: xi,yi,zi

   allocate( rxr(5))
   allocate( ryr(5))
   allocate( rzr(5))
   allocate(real :: xr(5))
   allocate(real :: yr(5))
   allocate(real :: zr(5))
   allocate(integer :: xi(5))
   allocate(integer :: yi(5))
   allocate(integer :: zi(5))


   call initialize_data(xr, yr, zr, xi, yi, zi, rzr )

   ! call send_dat(rxr,ryr,rzr)
   !Error: Actual argument to ‘x’ at (1) must be polymorphic
   call send_data(xr,yr,zr)
   call send_data(xi,yi,zi)
   call send_data_cs(xr,yr,zr)
   call send_data_cs(xi,yi,zi)
   

   rzr = rzr ** 2
   !!zr = zr ** 2
   !!Error: Operands of binary numeric operator ‘**’ at (1) are CLASS(*)/INTEGER(4)

   select type (zr)
   type is ( REAL )
     do i = 1,5
        print *, zr(i)
     end do
  end select

CONTAINS


   subroutine send_data_cs (x, y, z)
      CLASS(*), allocatable , dimension(:), intent(in) :: x,y
      CLASS(*), allocatable , dimension(:), intent(inout) :: z
      select type (x)
       type is ( REAL )
         select type (y)
          type is (REAL)
            select type (z)
             type is (REAL)
               print *, "calling real sd"
               call send_dat_r(x,y,z)
               !Error: Actual argument for ‘x’ must be ALLOCATABLE at (1)
            end select
         end select

       type is (INTEGER)
         print*, "calling int sd"
         !CALL send_dat_i(x,y,z)
       class default
         stop 'Error in send_dat type selection '
      end select

      PRINT *, "returning from send_dat"
   end subroutine send_data_cs


   subroutine initialize_data(xr, yr, zr, xi, yi, zi, rzr )
      real, intent(inout), allocatable,  dimension(:) :: rzr
      class(*), intent(inout), allocatable,  dimension(:) :: xr,yr,zr
      class(*), intent(inout), allocatable, dimension(:) :: xi,yi,zi

      select type (zr)
       type is ( REAL )
         zr = 1
         zr = zr ** 2
       class default
         print *, "err in simple select"
      end select

      select type (yr)
       type is ( REAL )
         yr = 1
      end select

      select type (xr)
       type is ( REAL )
         xr = 1
      end select

      select type (zi)
       type is ( INTEGER )
         zi = 1
      end select

      select type (yi)
       type is ( INTEGER )
         yi = 1
      end select

      select type (xi)
       type is ( INTEGER )
         xi = 1
      end select
   end subroutine initialize_data

end program test_send_data
