module sendf_i4_mod
    use platform_mod
    implicit none
    integer, parameter :: wp=i4_kind !working parameter
    include "sendf_int.F90"  !!NOTE this is not a #include
end module sendf_i4_mod