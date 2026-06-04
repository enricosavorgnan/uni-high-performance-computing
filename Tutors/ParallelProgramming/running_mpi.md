---
icon: material/wrench
---

# Running MPI on ORFEO

## Loading the MPI modules

In order to run mpi codes on the cluster, you need to be able to load the correct modules.
Please, refer to the [tutorial on modules](../Introduction/modules.md) for information on how to use the `module` command.
For the purpose of this tutorial, it will be sufficient to run `module load openMPI`.

So, allocate (see the [tutorial on slurm](../Introduction/using_slurm.md)) some resources on a node, say one of the GENOA partition, and then load the module[^1].
```console
jsalvalaggio@login01:~$ salloc -p GENOA -A lade -n 1 -N 1 --time 00:30:00
salloc: Granted job allocation 893203
salloc: Waiting for resource configuration
salloc: Nodes genoa001 are ready for job
jsalvalaggio@login01:~$ module load openMPI
```
Verify that the module was loaded correctly by calling one of the commands that should have been loaded, such as `mpicc`, `mpif90` or `mpirun`:
```console
jsalvalaggio@login01:~$ mpicc --version
gcc (GCC) 14.2.1 20250110 (Red Hat 14.2.1-7)
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```


## Compiling a simple MPI program in C

Let us consider a very simple MPI program in C that has each process print its rank - that is, its identifying number - and the total number of processes.
You do not necessarily need to know what is going on with the code; we just want to check you can run it.
```c title="hello.c"
#include <stdio.h>
#include <mpi.h>

void main(int argc, char **argv) {
    MPI_Init(&argc, &argv); // (1)!

    int process_count;
    MPI_Comm_size(MPI_COMM_WORLD, &process_count); // (2)!
    
    int process_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &process_rank); // (3)!

    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len); // (4)!
    
    printf("Hello, I am process #%i out of a total of %i, running on host %s.\n", process_rank, process_count, processor_name);
    
    MPI_Finalize(); // (5)!
}
```

1. Initialize the MPI processes. From here until `MPI_Finalize`, all lines of code will be executed in parallel on all processes.
2. Get total number of processes.
3. Get rank of the current process. This is different for each process and allows us to distinguish them.
4. Get host name of the processor.
5. End MPI block of code.

Assuming you have allocated the resources as shown in the previous section, you can compile the code via `srun mpicc hello.c -o hello.x`.
The `-o` is an option of the C compiler that allows us to choose the name of the output executable.
Without specifying it, the default name is `a.out`.

Indeed, `mpicc` is just a wrapper for the C compiler (in our case, `gcc`) that includes the information on the MPI libraries to include, so you can pass it any flag or option you would normally use to compile any C code.
You can verify this with the `--showme` flag:
```console
jsalvalaggio@login01:~$ mpicc --showme hello.c -o hello.x
gcc hello.c -o hello.x -I/opt/programs/openMPI/5.0.5/include -L/opt/programs/openMPI/5.0.5/lib -Wl,-rpath -Wl,/opt/programs/openMPI/5.0.5/lib -Wl,--enable-new-dtags -lmpi
```

!!! tip

    The same steps, substituting `mpicc` with `mpif90`, apply to any MPI code written in FORTRAN90.


## Running a simple MPI program in C

We are now going to run the code.
First off, free the resources used earlier to compile `hello.c` since we will need a new allocation with more than one task.
Every task allocated basically translates to an MPI process, so having one task means running the code serially.
Let us ask for, say, five tasks and then run the code with `mpirun`.
```console
jsalvalaggio@login01:~$ salloc -p GENOA -A lade -n 5 -N 1 --time 00:30:00
salloc: Granted job allocation 931455
salloc: Waiting for resource configuration
salloc: Nodes genoa002 are ready for job
jsalvalaggio@login01:~$ module load openMPI
jsalvalaggio@login01:~$ mpirun hello.x 
Hello, I am process #2 out of a total of 5, running on host genoa002.hpc.rd.areasciencepark.it.
Hello, I am process #3 out of a total of 5, running on host genoa002.hpc.rd.areasciencepark.it.
Hello, I am process #4 out of a total of 5, running on host genoa002.hpc.rd.areasciencepark.it.
Hello, I am process #0 out of a total of 5, running on host genoa002.hpc.rd.areasciencepark.it.
Hello, I am process #1 out of a total of 5, running on host genoa002.hpc.rd.areasciencepark.it.
```
Success! Each one of our five processes has executed the code contained between `MPI_Init` and `MPI_Finalize`, printing information on its rank and host name.

!!! tip

    Notice how we **did not** `srun mpirun` but only `mpirun`.
    This is the intended behaviour in ORFEO, as `mpirun` can interface with SLURM and discover the resources that have been allocated at that moment.
    This is not, however, the guaranteed behaviour in all clusters.
    Please do check that your MPI program is properly running!


??? question "Subtleties on tasks and nodes"

    Let us go back to the previous example to clear up a point.
    There, we have allocate 5 tasks (i.e. 5 cpus, if the option `-c` is left to its default value) on one single node.
    Indeed, the name of the host printed for each process is the same.
    However, we can also run our MPI code across multiple nodes by tweaking the options passed to `salloc`:
    ```console
    jsalvalaggio@login01:~$ salloc -p GENOA -A lade -N 5 --ntasks-per-node=1 --time 00:30:00
    salloc: Granted job allocation 931461
    salloc: Waiting for resource configuration
    salloc: Nodes genoa[005-009] are ready for job
    jsalvalaggio@login01:~$ module load openMPI
    jsalvalaggio@login01:~$ mpirun hello.x 
    Hello, I am process #1 out of a total of 5, running on host genoa006.hpc.rd.areasciencepark.it.
    Hello, I am process #3 out of a total of 5, running on host genoa008.hpc.rd.areasciencepark.it.
    Hello, I am process #0 out of a total of 5, running on host genoa005.hpc.rd.areasciencepark.it.
    Hello, I am process #2 out of a total of 5, running on host genoa007.hpc.rd.areasciencepark.it.
    Hello, I am process #4 out of a total of 5, running on host genoa009.hpc.rd.areasciencepark.it.
    ```
    We can also assign more than a task per node:
    ```console
    jsalvalaggio@login01:~$ salloc -p GENOA -A lade -n 9 -N 5 --ntasks-per-node=2 --time 00:30:00
    salloc: Granted job allocation 932214
    salloc: Waiting for resource configuration
    salloc: Nodes genoa[005-009] are ready for job
    jsalvalaggio@login01:~$ module load openMPI
    jsalvalaggio@login01:~$ mpirun hello.x 
    Hello, I am process #6 out of a total of 9, running on host genoa008.hpc.rd.areasciencepark.it.
    Hello, I am process #7 out of a total of 9, running on host genoa008.hpc.rd.areasciencepark.it.
    Hello, I am process #2 out of a total of 9, running on host genoa006.hpc.rd.areasciencepark.it.
    Hello, I am process #0 out of a total of 9, running on host genoa005.hpc.rd.areasciencepark.it.
    Hello, I am process #3 out of a total of 9, running on host genoa006.hpc.rd.areasciencepark.it.
    Hello, I am process #1 out of a total of 9, running on host genoa005.hpc.rd.areasciencepark.it.
    Hello, I am process #4 out of a total of 9, running on host genoa007.hpc.rd.areasciencepark.it.
    Hello, I am process #5 out of a total of 9, running on host genoa007.hpc.rd.areasciencepark.it.
    Hello, I am process #8 out of a total of 9, running on host genoa009.hpc.rd.areasciencepark.it.
    ```
    Notice how the `-n` option has overridden the `--ntasks-per-node`: two tasks were assigned to each node until reaching the total number we asked for (i.e. 9).
    Indeed, you can see `genoa009` is only hosting one process.


[^1]: We are going to ask for just one task at this stage since we will only use the resources here allocated to compile the code. To run it, we will need to ask for at least two tasks to actually make it parallel.

<br>
Authors: Niccolò Tosato, Jacopo Salvalaggio
