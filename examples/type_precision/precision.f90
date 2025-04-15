program float_precision
    ! module provides kind perams for 32 and 64 bit floating-point types
    ! Very flexible naming of imported params which can also be used as
    ! literal suffix
    use, intrinsic :: iso_fortran_env, only: p32=>real32, dp=>real64
    implicit none

    ! 'kind' perameters
    real(p32) :: float32
    real(dp) :: float64

    ! Explicit literal suffix
    ! Note how these are defined by programmer above
    ! Interesting feature
    float32 = 1.0_p32
    float64 = 1.0_dp
    print *, float32, float64

end program float_precision
