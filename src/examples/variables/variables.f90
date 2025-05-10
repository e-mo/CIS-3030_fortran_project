program variables
    ! Always use implicit none. This tells compiler that all variables
    ! must be implicitly typed. Implicit typing in modern Fortran is
    ! considered a code smell.
    implicit none

    ! Variable declaration
    integer   :: amount
    real      :: pi, e
    complex   :: frequency
    character :: initial
    logical   :: isOkay

    ! Variable assignment
    amount = 10
    pi = 3.1415927
    frequency = (1.0, -0.5)
    initial = 'A'
    isOkay = .false.

    print *, 'The value of amount (integer) is: ', amount
    print *, 'The value of pi (real) is: ', pi
    print *, 'The value of frequency (complex) is: ', frequency
    print *, 'The value of initial (character) is: ', initial
    print *, 'The value of isOkay (logical) is: ', isOkay

end program variables
