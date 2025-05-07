! file: ecs_fortran.f90
program ecs_fortran
  use components_mod  ! component and component_array
  use operations_mod  ! batch_operation function def
  use process_mod     ! process and op_inderface
  implicit none

  ! Parameters
  integer, parameter :: num_entities       = 1000000
  integer, parameter :: process_iterations = 10000

  ! Variables
  integer :: i, rand_mod, start_clock, end_clock, clock_rate
  real(8) :: cpu_time
  character(len=6) :: tstr, astr
  type(process_type) :: math_process
  integer, allocatable :: entity_ids(:)

  ! External packed arrays (cache-local), declared as POINTER
  type(component), pointer :: pack1(:), pack2(:)

  ! ECS component-array wrappers
  type(component_array), target :: comp_array_1, comp_array_2

  ! Temporary helper component
  type(component) :: temp_comp

  ! Initialization
  call random_seed()
  allocate(entity_ids(num_entities))

  ! Generate reversed IDs
  forall (i = 1:num_entities)
    entity_ids(i) = num_entities - i
  end forall

  ! Allocate the packed buffers
  allocate(pack1(num_entities), pack2(num_entities))

  ! Initialize component-array wrappers with external buffers
  call init_component_array(comp_array_1, num_entities, pack1)
  call init_component_array(comp_array_2, num_entities, pack2)

  ! Register entities into wrappers
  temp_comp = component(0, 0, 0)
  do i = 1, num_entities
    call register_id(comp_array_1, entity_ids(i)+1, temp_comp)
    call register_id(comp_array_2, entity_ids(i)+1, temp_comp)
  end do

  ! Fill buffers with random components
  rand_mod = 100
  do i = 1, num_entities
    call random_component(temp_comp, rand_mod)
    pack1(i) = temp_comp
    call random_component(temp_comp, rand_mod)
    pack2(i) = temp_comp
  end do

  ! Setup process and run
  allocate(math_process%results(num_entities))
  math_process%operation => batch_operation
  math_process%input1    => comp_array_1
  math_process%input2    => comp_array_2

  ! Time the batch operation
  call system_clock(start_clock, clock_rate)
  do i = 1, process_iterations
    call math_process%operation(comp_array_1%packed_array, &
                                comp_array_2%packed_array, &
                                math_process%results,      &
                                comp_array_1%registered)
  end do
  call system_clock(end_clock)

  ! Results
  cpu_time = dble(end_clock - start_clock) / dble(clock_rate)
  
  ! Prepare zero-padded strings
  write(tstr, '(F5.2)') cpu_time
  if (tstr(1:1) == ' ') tstr(1:1) = '0'
  write(astr, '(F5.2)') (cpu_time*1000)/process_iterations
  if (astr(1:1) == ' ') astr(1:1) = '0'

  ! Print results with aligned colons
  print '(A,I0)',  '              entities: ', num_entities
  print '(A,I0)',  '            iterations: ', process_iterations
  print '(A,A,A)', '    total process time: ', tstr, 's'
  print '(A,A,A)', 'average iteration time: ', astr, 'ms'

end program ecs_fortran
