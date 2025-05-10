! Handling errors instead of just crashing on bad read
program error_handle
    ! trim(string) trims the blank chars off end of string
    implicit none
    real :: x
    integer :: ierr
    character(len=80) :: buffer, msg
    if (command_argument_count() < 1) then
        write (*, fmt='(A)') &
            '### error: expecting a real as argument'
        stop 1
    else if (command_argument_count() > 1) then
        write (*, fmt='(A)') &
            'You added extra args, silly! Throwing them away...'
    end if
    
    call get_command_argument(1, buffer)
    read (buffer, fmt='(F25.16)', iostat=ierr, iomsg=msg) x
    if (ierr /= 0) then
        write (*, fmt='(4A)') &
            '### error: can not convert to real: ', trim(buffer), &
            ', ', trim(msg)
        stop 2
    else 
        write (*, fmt='(XAA)') '-> ', trim(buffer)
    end if
end program error_handle
