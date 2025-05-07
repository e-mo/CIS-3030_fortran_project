program float_precision
    ! use, intrinsic :: ... <- for importing Fortran built-in modules
    ! iso_fortran_env provides kind perams for 32 and 64 bit floating-point 
    ! Very flexible naming of imported params which can also be used as
    ! a literal suffix
    use, intrinsic :: iso_fortran_env, only: r32=>real32, dp=>real64
    implicit none

    ! 'kind' perameters when declaring variables
    real(r32) :: float32
    real(dp) :: float64

    ! Explicit literal suffix
    ! Note how these are not static and are defined in 'use, intrinsic' statement
    float32 = 1.0_r32
    float64 = 1.0_dp
    print *, float32, float64

end program float_precision
