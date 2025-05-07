! file: components_mod.f90
module components_mod
  implicit none

  ! Component data structure
  type :: component
    integer :: x, y, z
  end type component

  ! ECS-style component array storage
  type :: component_array
    integer :: registered = 0
    integer :: array_size = 0
    integer, allocatable      :: sparse_array(:)
    integer, allocatable      :: id_array(:)
    type(component), pointer  :: packed_array(:)
  end type component_array

contains

  ! Allocate and initialize component array; bind external packed_array
  subroutine init_component_array(arr, size, pack)
    type(component_array), intent(inout) :: arr
    integer, intent(in)                 :: size
    type(component), pointer, intent(in):: pack(:)

    arr%array_size      = size
    allocate(arr%sparse_array(size))
    allocate(arr%id_array(size))
    arr%sparse_array    = -1
    arr%registered      = 0

    ! bind the outside-allocated packed array for cache locality
    arr%packed_array    => pack
  end subroutine init_component_array

  ! Register an ID into the component array
  subroutine register_id(arr, id, init_val)
    type(component_array), intent(inout) :: arr
    integer, intent(in)                  :: id
    type(component), intent(in)          :: init_val

    ! Check inputs
    if (id > arr%array_size .or. arr%sparse_array(id) /= -1) return 

    arr%sparse_array(id) = arr%registered + 1
    arr%id_array(arr%registered+1) = id
    arr%packed_array(arr%registered+1) = init_val
    arr%registered = arr%registered + 1
  end subroutine register_id

  subroutine set_component(arr, id, new_val)
    type(component_array), intent(inout) :: arr
    integer, intent(in)                  :: id
    type(component), intent(in)          :: new_val
    integer :: packed_index

    ! Check inputs
    if (id > arr%array_size .or. arr%sparse_array(id) == -1) return 

    packed_index = arr%sparse_array(id)

    arr%packed_array(packed_index) = new_val

  end subroutine set_component

  ! Fill a component with random x/y/z values from 1 to modval
  subroutine random_component(c, modval)
    type(component), intent(out) :: c
    integer, intent(in)          :: modval
    real :: r
    call random_number(r); c%x = int(modval * r) + 1
    call random_number(r); c%y = int(modval * r) + 1
    call random_number(r); c%z = int(modval * r) + 1
  end subroutine random_component

end module components_mod
