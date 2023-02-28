program time_pow_function

    integer :: vn(20), va(20)
    integer :: i, NV
    real, allocatable :: val(:)
    real :: start, finish, sum
    
    NV=10000000
    allocate(val(NV))

    DO i = 1,NV
        val(i) = (0.1 * i ) / NV
    end DO

    

    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 2)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 2) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum

    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 2.0)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 2.0) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum

    
    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 3)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 3) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum


    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 1)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 1) time= ",f6.4," seconds. Sum was:",f9.2)',finish-start, sum


    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + val(i) * val(i)
    end DO
    call cpu_time(finish)
    print '("For val(i)*val(i). time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum


    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + exp(2.0 * log(val(i)))
    end DO
    call cpu_time(finish)
    print '("For exp(2.0 * log(val(i))). time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum
    
    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 3.0)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 3.0) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum

    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 2.01)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 2.01) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum

    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 2.5)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 2.5) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum

    sum = 0.0
    call cpu_time(start)
    DO i = 1,NV
        sum = sum + (val(i) ** 3.1)
    end DO
    call cpu_time(finish)
    print '("For (val(i) ** 3.1) time= ",f6.4," seconds. Sum was:",f8.2)',finish-start, sum


end program time_pow_function