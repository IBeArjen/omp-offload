program dtype_acc
  implicit none

  integer, parameter  :: dp = selected_real_kind(15,300)

  type  :: dtype_array
    real(kind=dp),dimension(:),allocatable  :: dp_vals
  end type dtype_array

  !!$omp declare mapper (dtype_array :: dt) use_by_default map(dt, dt%dp_vals(1:size(dp_vals)))

  type(dtype_array)   :: dt
  integer             :: i,j

  allocate(dt%dp_vals(128))
  dt%dp_vals = 0.0_dp

  !Loop a billion times to show up on nvidia-smi...
  !$omp target data map(to:dt)
  ! $omp target data map(tofrom:dt%dpvals)
  !$omp target teams distribute parallel do
  do j=1,1000000000
    do i=1,128
      dt%dp_vals(i) = dt%dp_vals(i) + real(i)
    end do
  end do
  !$omp end target teams distribute parallel do
  ! $omp end target data
  !$omp end target data

  write(*,*) dt%dp_vals

  deallocate(dt%dp_vals)

end program dtype_acc
