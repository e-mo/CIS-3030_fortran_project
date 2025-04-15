program arithmetic_ops
    implicit none

    real :: a, b, add, sub, mult, div, power

    a = 10.0
    b = 3.0

    ! Perform arithmetic operations
    add   = a + b       ! Addition
    sub   = a - b       ! Subtraction
    mult  = a * b       ! Multiplication
    div   = a / b       ! Division
    power = a ** b      ! Exponentiation

    print *, "a = ", a
    print *, "b = ", b
    print *, "Addition (a + b)        = ", add
    print *, "Subtraction (a - b)     = ", sub
    print *, "Multiplication (a * b)  = ", mult 
    print *, "Division (a / b)        = ", div
    print *, "Exponentiation (a ** b) = ", power

end program arithmetic_ops

