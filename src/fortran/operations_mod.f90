! file: operations_mod.f90
module operations_mod
  use components_mod
  implicit none

  ! Subroutine interface to provide a generic type for passing
  ! operation routines
  abstract interface
    subroutine op_interface(comp1, comp2, results, size)
      import :: component
      type(component), intent(in)    :: comp1(:), comp2(:)
      integer,      intent(inout)    :: results(:)
      integer,      intent(in)       :: size
    end subroutine op_interface
  end interface

contains

  ! batch_operation: perform a computation on two component arrays
  !     comp1/comp2: input component buffers (packed component arrays)
  !         results: integer results array
  !            size: number of active entries in the buffers
  subroutine batch_operation(comp1, comp2, results, size)
    type(component), intent(in)    :: comp1(:)
    type(component), intent(in)    :: comp2(:)
    integer,       intent(inout)   :: results(:)
    integer,       intent(in)      :: size
    integer :: i
    real :: r

    ! Choose a random divisor between 1 and 3
    call random_number(r)
    r = mod(int(r * 1000), 3) + 1

    ! Compute result for each element
    do i = 1, size
      results(i) = comp1(i)%x + comp2(i)%x &
                 + comp1(i)%x + comp2(i)%y &
                 + comp1(i)%x + comp2(i)%z
      results(i) = results(i) + comp1(i)%y + comp2(i)%x
      results(i) = results(i) - comp2(i)%z
      results(i) = results(i) + comp2(i)%z * comp1(i)%z
      results(i) = results(i) / r
    end do
  end subroutine batch_operation

end module operations_mod

