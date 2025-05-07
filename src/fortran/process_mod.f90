! file: process_mod.f90
module process_mod
  use components_mod
  use operations_mod
  implicit none

  type :: process_type
    procedure(op_interface), pointer, nopass :: operation
    type(component_array), pointer            :: input1
    type(component_array), pointer            :: input2
    integer, allocatable                      :: results(:)
  end type process_type

end module process_mod
