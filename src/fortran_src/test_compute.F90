program test_compute
    use compute_all

    real(kind=4), dimension(5) :: x4,y4,z4
    real(kind=8), dimension(5) :: x8,y8,z8

    print *, "In test_compute"

    call compute(x4,y4,z4)
    call compute(x8,y8,z8)

end program test_compute

