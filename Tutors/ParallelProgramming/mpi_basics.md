---
icon: material/land-rows-horizontal
---

# Basics of MPI coding

MPI code works by coordinating the execution of code across various cpus or *processes*.


## Initializing and finalizing the MPI environment

In order to run MPI code, we must tell the compiler when to start and stop distributing the workload across the available processes.
We can do so via the initialize and finalize routines.

=== "C"

    ```c
    #include <stdio.h>
    #include <mpi.h>

    int main(int argc, char **argv) {
        MPI_Init(&argc, &argv);
        printf("I am a process, I am alive.\n");
        MPI_Finalize();
        return 0;
    }
    ```

=== "FORTRAN 90"

    ```f90
    program init_finalize
        implicit none
        include 'mpif.h'
        integer :: error
        call mpi_init(error)
        print *, "I am a process, I am alive."
        call mpi_finalize(error)
    end program init_finalize
    ```

If you compile and execute the code above, you will see the message is printed *n* times, where *n* is the number of tasks seen when `mpirun` launches the code.
This proves that the code block between the initialize and finalize routine runs on every process available.


## Retrieving process count and rank

In order to organize the workflow of the program, we need to be able to tell which process we are interacting with.
We can do so by retrieving the *rank* of said process, that is basically its identifying number.

=== "C"

    ```c
    #include <stdio.h>
    #include <mpi.h>

    int main(int argc, char **argv) {
        int cpu_count, cpu_rank;
        MPI_Init(&argc, &argv);
        // Get total number of processes (size)
        MPI_Comm_size(MPI_COMM_WORLD, &cpu_count);
        // Get rank of the process
        MPI_Comm_rank(MPI_COMM_WORLD, &cpu_rank);
        printf("Hello, I am process with rank %i out of a total of %i processes.\n", cpu_rank, cpu_count);
        MPI_Finalize();
        return 0;
    }
    ```

=== "FORTRAN 90"

    ```f90
    program hello_world
        implicit none
        include 'mpif.h'
        integer :: error, cpu_rank, cpu_count
        call mpi_init(error)
        ! Get total number of processes (size)
        call mpi_comm_size(mpi_comm_world, cpu_count, error)
        ! Get rank of the process
        call mpi_comm_rank(mpi_comm_world, cpu_rank, error)
        print *, "Hello, I am process with rank", cpu_rank, " out of a total of ", cpu_count, " processes."
        call mpi_finalize(error)
    end program hello_world
    ```

The total number of processes available depends on the resources allocated for the job.
If you ask SLURM for 10 tasks (and invoke `mpirun` without using the `-n` option) you will see processes from 0 to 9 printing on screen, in a random order.


## Sending and receiving data

Communication between processes is the foundation of MPI coding.
There are a number of ways for different processes to exchange data, the most basic being the send and receive functions.
Note that variables modified in different processes are independent from one another unless explicit communication has taken place.
In other words, if I assign a variable `x` a certain value over one process, other processes will not see this value unless it is broadcast to them some way.
The following code gives a working example of a simple communication between two processes.
Each of them stores a random number (crucially, the two numbers are different) and then the process `SENDER` sends its number to `RECEIVER`.

=== "C"

    ```c
    #include <stdio.h>
    #include <stdlib.h>
    #include <mpi.h>

    #define SENDER 2
    #define RECEIVER 8

    int main(int argc, char **argv) {
        int random_message = 0;
        int cpu_rank;
        MPI_Status status;
        MPI_Init(&argc, &argv);
        MPI_Comm_rank(MPI_COMM_WORLD, &cpu_rank);
        srand(cpu_rank);
        random_message = rand();
        if ((cpu_rank == SENDER) || (cpu_rank == RECEIVER)) {
            printf("#%i: random message is %i.\n", cpu_rank, random_message);
            if (cpu_rank == SENDER) {
                MPI_Send(&random_message, 1, MPI_INT, RECEIVER, 1, MPI_COMM_WORLD);
            }
            else {
                MPI_Recv(&random_message, 1, MPI_INT, SENDER, 1, MPI_COMM_WORLD, &status);
                printf("#%i: random message received from #%i is %i.\n", cpu_rank, SENDER, random_message);
            }
        }
        MPI_Finalize();
        return 0;
    }
    ```

=== "FORTRAN 90"

    ```f90
    program communicate
        implicit none
        include 'mpif.h'
        integer, parameter :: SENDER = 2, RECEIVER = 8
        integer :: error, cpu_rank, cpu_count
        integer, dimension(1:mpi_status_size) :: status
        real(4) :: random_message
        call mpi_init(error)
        call mpi_comm_rank(mpi_comm_world, cpu_rank, error)
        call random_seed()
        call random_number(random_message)
        if ((cpu_rank == SENDER) .or. (cpu_rank == RECEIVER)) then
            print *, "#", cpu_rank, ": random message is ", random_message, "."
            if (cpu_rank == SENDER) then
                call mpi_send(random_message, 1, mpi_integer, RECEIVER, 1, mpi_comm_world, error)
            else
                call mpi_recv(random_message, 1, mpi_integer, SENDER, 1, mpi_comm_world, status, error)
                print *, "#", cpu_rank, ": random message received from #", SENDER, " is ", random_message, "."
            end if
        end if
        call mpi_finalize(error)
    end program communicate
    ```

!!! warning 

    Note that for this code to work you have to allocate *at least* 9 processes since the rank of the receiver is set to 8.
    You can freely edit it in order to make it usable on different setups.


<br>
Authors: Jacopo Salvalaggio, Niccolò Tosato
