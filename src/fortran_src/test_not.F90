program test_not

    integer :: vn(20), va(20)
    logical :: mask(20)
    integer :: i

    mask = .false.
    vn = 0
    va = 0


    do i = 1,20
        if (mod(i,2) == 0) then  !! evens set to true.
            mask(i) = .true.
        end if
    end do

  
    where (.not. mask(:))  vn(:) = 1
    where (mask(:) .eqv. .false. ) va (:)= 1

    print *, "i, mask(i), vn(i), va(i)"
    do i = 1,20
        print *,i, mask(i), vn(i), va(i)
    end do

end program test_not