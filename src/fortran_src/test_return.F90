program test_return

    integer, allocatable:: the_array_fs(:), the_array_fh(:)

    the_array_fs = get_init_from_stack(2)

    the_array_fh = get_init_from_heap(2)

    if(.not. allocated(the_array_fs)) then
        print *, "The_array_fs is NOT allocated"
    else
        print *, "The_array_fs is allocated"
        print *, "array:", the_array_fs
    endif

    if(.not. allocated(the_array_fh)) then
        print *, "The_array_fh is NOT allocated"
    else
        print *, "The_array_fh is allocated"
        print *, "array:", the_array_fh
    endif

    CONTAINS
    function get_init_from_heap(iv) result(arr)
        integer, intent(in) :: iv
        integer, allocatable, dimension(:) :: arr
        allocate(arr(10))
        arr = iv
    end function get_init_from_heap

    function get_init_from_stack(iv) result(arr)
        integer,intent(in) :: iv
        integer,  dimension(10) :: arr
        arr = iv
    end function get_init_from_stack

end program test_return