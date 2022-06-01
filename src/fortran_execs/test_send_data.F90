!! test_send_data is merely for testing the send_data interface prototype,
!! particularly for using class(*) data arguments and alternatives.

program test_send_data

   use send_data_mod, only : send_data
   !!note we do not directly need to use the send_data_r_mod
   !! or the send_data_i_mod

   implicit none

   integer i

   !!There are three types of data:
   class(*), allocatable,  dimension(:) :: xrc,yrc,zrc
   class(*), allocatable, dimension(:) :: xic,yic,zic
   real, allocatable,  dimension(:) :: xr,yr,zr
   integer, allocatable, dimension(:) :: xi,yi,zi

   allocate(real :: xrc(5))
   allocate(real :: yrc(5))
   allocate(real :: zrc(5))
   allocate(integer :: xic(5))
   allocate(integer :: yic(5))
   allocate(integer :: zic(5))

   allocate(xr(5))
   allocate(yr(5))
   allocate(zr(5))
   allocate(xi(5))
   allocate(yi(5))
   allocate(zi(5))

   call initialize_data_C(xrc, yrc, zrc, xic, yic, zic)
   call initialize_data(xr, yr, zr, xi, yi, zi)

   !! Using some interfaces are OK but some (in comments below)
   !!  will not (and should not) compile. Note that although in 
   !!   principle we can move send_data_cs to a module 
   !!   the send_data_i and send_data_r, but the same generation
   !!  script will not work.

   print *, "using send_data with xr:"
   call send_data(xr,yr,zr)

   print *, "using send_data with xi:"
   call send_data(xi,yi,zi)

   !!call send_data_cs(xr,yr,zr)
   !Error: Actual argument to ‘x’ at (1) must be polymorphic

   print *, "using send_data_cs with xrc"
   call send_data_cs(xrc,yrc,zrc)

   print *, "using send_data_cs with xic"
   call send_data_cs(xic,yic,zic)

   select type (zrc)
    type is ( REAL )
      do i = 1,5
         print *, zrc(i)
      end do
   end select

   call check_power_function(zi, zr, zrc)

CONTAINS

   !!send_data with class(*) args. Its a wrapper to the other
!! sned_data functions.
   subroutine send_data_cs (x, y, z)
      CLASS(*), allocatable , dimension(:), intent(in) :: x,y
      CLASS(*), allocatable , dimension(:), intent(inout) :: z
      select type (x)
       type is ( REAL )
         select type (y)
          type is (REAL)
            select type (z)
             type is (REAL)
               call send_data(x,y,z)
               !!call send_dat_r(x,y,z) !!OR can  _R version if its visible.
            end select
         end select
       type is (INTEGER)
         select type (y)
          type is (INTEGER)
            select type(z)
             type is (INTEGER)
               call send_data(x,y,z)
               !!call send_dat_r(x,y,z) !!OR can  _I version if its visible.
            end select
         end select
       class default
         stop 'Error in send_dat type selection '
      end select

      PRINT *, "returning from send_data_cs"
   end subroutine send_data_cs


   subroutine initialize_data_c(xr, yr, zr, xi, yi, zi )
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
   end subroutine initialize_data_c

   subroutine initialize_data(xr, yr, zr, xi, yi, zi )
      real, intent(inout), allocatable,  dimension(:) :: xr,yr,zr
      integer, intent(inout), allocatable, dimension(:) :: xi,yi,zi

      zr = 1
      zr = zr ** 2
      yr = 1
      xr = 1
      zi = 1
      yi = 1
      xi = 1

   end subroutine initialize_data

   subroutine check_power_function(zi, zr, zrc)
      integer,  dimension(:), intent(inout) ::zi
      real,     dimension(:), intent(inout) ::zr
      class(*), dimension(:), intent(inout) ::zrc

   !!POWER operator works with reals, ints, BUT NOT CLASS(*)
   ZR = 1
   zr = zr ** 2  !!POWER operator works with reals, ints, 
   zr = 1
   zi = 1
   zi = zi ** 2
   zi = 1

   !!zrc = zrc ** 2 
   !!Error: Operands of binary numeric operator ‘**’ at (1) are CLASS(*)/INTEGER(4)

   select type (zrc)
   type is ( REAL )
      ZRC = ZRC ** 2
  end select

end subroutine check_power_function

end program test_send_data
