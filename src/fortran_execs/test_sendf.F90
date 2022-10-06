!! test_send_data is merely for testing the send_data interface prototype,
!! particularly for using class(*) data arguments and alternatives.

program test_sendf
   use platform_mod
   use sendf_mod, only : sendf
   !use sendf_int_mod, only : sendf_int
   !!note we do not directly need to use the send_data_r_mod
   !! or the send_data_i_mod

   implicit none

   integer i

   !!There are three types of data:
   class(*), allocatable,  dimension(:) :: xrc,yrc,zrc
   class(*), allocatable, dimension(:) :: xic,yic,zic
   real(kind=r4_kind), allocatable,  dimension(:) :: xr,yr,zr
   integer(kind=i4_kind), allocatable, dimension(:) :: xi,yi,zi
   integer(kind=i4_kind), dimension(5) :: xi_na,yi_na,zi_na

   allocate(real(r4_kind) :: xrc(5))
   allocate(real(r4_kind) :: yrc(5))
   allocate(real(r4_kind) :: zrc(5))
   allocate(integer(i4_kind) :: xic(5))
   allocate(integer(i4_kind) :: yic(5))
   allocate(integer(i4_kind) :: zic(5))

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
   call sendf(xr,yr,zr)

   print *, "using send_data with xi:"
   call sendf(xi_na,yi_na,zi_na)

   !!call send_data_cs(xr,yr,zr)
   !Error: Actual argument to ‘x’ at (1) must be polymorphic

   print *, "using send_data_cs with xrc"
   !call send_data_cs(xrc,yrc,zrc)

   print *, "using send_data_cs with xic"
   !call send_data_cs(xic,yic,zic)

   select type (zrc)
    type is ( REAL )
      do i = 1,5
         print *, zrc(i)
      end do
   end select

   call check_power_function(zi, zr, zrc)

CONTAINS

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


   !!send_data with class(*) args. Its a wrapper to the other
!! send_data functions.
   subroutine send_data_cs (x, y, z)
      CLASS(*), allocatable , dimension(:), intent(in) :: x,y
      CLASS(*), allocatable , dimension(:), intent(inout) :: z
      select type (x)
       type is (real(kind=r4_kind))
         select type (y)
          type is (real(kind=r4_kind))
            select type (z)
             type is (real(kind=r4_kind))
               call sendf(x,y,z)
               !!call send_dat_r(x,y,z) !!OR can  _R version if its visible.
            end select
         end select
       type is (integer(kind=i4_kind))
         select type (y)
          type is (integer(kind=i4_kind))
            select type(z)
             type is (integer(kind=i4_kind))
               call sendf(x,y,z)
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

end program test_sendf
