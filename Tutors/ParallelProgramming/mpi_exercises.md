---
icon: material/dumbbell
---

# MPI Exercises

## Simple exercises

### Parallel Hello World

Write a program that makes every process print a greeting message detailing their rank and the total number of processes.

```c title="hello_world.c"
#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv) {

    int process_count, process_rank;

    /* 
     * Initialize the MPI environment...
     * ...
     * Get ranks and total number of processes...
     * ...
     */

    printf("Hello World! I am process with rank %i out of a total of %i processes.\n", process_rank, process_count);

    /*
     * Finalize the MPI environment...
     */

    return 0;
}
```

### Ping pong

The following is a program to perform a simple ping-pong, i.e. check the back-and-forth communication between two different processes.
Read the code carefully and understand what it does before running it, do ask if you have doubts.
Check the output: it will show you the time it takes to send a packet of a certain size *N* times.
Try to run the code on different partitions and different configurations, for example asking tasks on separate nodes, and see how it impacts the performance.
Also, see what happens when you change the send method to synchronous, ready or buffered.

!!! warning

    If the code fails to run for the largest message sizes, it may be due to a lack of memory.
    You can customize the sizes by changing the code or simply modifying the `MAX_MESSAGE_SIZE_EXPONENT` variable.

```c title="ping_pong.c"
/* ----------------------------------------------
 * |                                            |
 * | PING PONG                                  |
 * |                                            |
 * | A simple code to test the communication    |
 * | between two processes. Best to run it with |
 * | two tasks total.                           |
 * | Try and see what happens when the send     |
 * | method is changed or when tasks are        |
 * | allocated on different nodes.              |
 * |                                            |
 * | Jacopo Salvalaggio                         |
 * |                                            |
 * ----------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>

#define N_TRIALS_DEFAULT 10
#define MAX_MESSAGE_SIZE_EXPONENT 30

int ipow(int base, int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
        result = result * base;
    }
    return result;
}

int main(int argc, char **argv) {

    /* We will send the message many times to 
     * get a reliable average.
     * First, we set the number of trials. */
    int n_trials = ( argc > 1 ? atol(*(argv + 1)) : N_TRIALS_DEFAULT);
    /* Initialize MPI */
    MPI_Init(&argc, &argv);
    int process_count, process_rank;
    MPI_Comm_size(MPI_COMM_WORLD, &process_count);
    MPI_Comm_rank(MPI_COMM_WORLD, &process_rank);
    /* Check that we have at least two procs */
    if (process_count < 2) {
        printf("At least two processes (tasks) are required for the ping pong.\n");
        return 1;
    }
    /* Print help message on how to parse output */
    if (process_rank == 0) {
        printf(
            "# To parse this output efficiently, you can use grep and cut.\n"
            "# Try and pipe the output of this code to: `grep -v '#' | cut -d' ' -f9,12`.\n"
        );
    }
    /* We will send messages of different size
     * to estimate how the time to deliver
     * them changes */
    for (int size_exponent = 0; size_exponent < MAX_MESSAGE_SIZE_EXPONENT + 1; size_exponent++) {
        /* Allocate messages */
        int message_size = ipow(2, size_exponent);
        char *message_in  = (char*) malloc(sizeof(char) * message_size);
        char *message_out = (char*) malloc(sizeof(char) * message_size);
        /* Allocate MPI status */
        MPI_Status status;
        /* Start timer */
        clock_t start_clock = clock(); 
        /* Start loop on number of trials */
        for (int i = 0; i < n_trials; i++) {
            /* Exchange a message between process 0 and 1 */
            if (process_rank == 0) {
                MPI_Send(message_out, message_size, MPI_CHAR, 1, 64, MPI_COMM_WORLD);
                MPI_Recv(message_in, message_size, MPI_CHAR, 1, 65, MPI_COMM_WORLD, &status);
            }
            else if (process_rank == 1) {
                MPI_Recv(message_in, message_size, MPI_CHAR, 0, 64, MPI_COMM_WORLD, &status);
                MPI_Send(message_out, message_size, MPI_CHAR, 0, 65, MPI_COMM_WORLD);
            }
        }
        /* End timer and compute time */
        time_t end_clock = clock();
        if (process_rank == 0) {
            double elapsed = ((double) end_clock - start_clock) / CLOCKS_PER_SEC;
            printf("Elapsed time to send %i messages of size %i bytes is %f s.\n", n_trials, message_size, elapsed);
        }
        /* Free memory */
        free(message_in);
        free(message_out);
    }
    /* Finalize */
    MPI_Finalize();
    return 0;
}
```

### Simple operations on an array

Open exercise: write a code to parallelize a simple operation on an array, for example squaring each element of the array. Divide the array in chunks and then collect the results. Use both process-to-process communication and collective MPI.

## More examples and exercises by Luca Tornatore

### Send & Receive

In this code, different processes communicate with each other by sending and receiving information on their respective ranks.
Notice how the code is safe and will not result in a deadlock due to the way `Send` and `Recv` are ordered: the first block of code to be executed first sends and then receives, while the second block of code behaves in the opposite way, first receiving the sent message and then replying.

```c title="send_and_recv.c"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <mpi.h>


int main ( int argc, char **argv )
{

  int Rank;
  int Ntasks;

  MPI_Init ( &argc, &argv );

  MPI_Comm_rank( MPI_COMM_WORLD, &Rank );
  MPI_Comm_size( MPI_COMM_WORLD, &Ntasks );

  char hostname[100];
  int hostname_size = 100;
  gethostname( &hostname[0], hostname_size );

  printf( "Rank %d is running on host %s\n", Rank, hostname );

  MPI_Barrier(MPI_COMM_WORLD);
  
  int Im_even = (Rank % 2 == 0);
  int my_buddy;
  if ( Im_even )
    my_buddy = Rank+1;
  else
    my_buddy = Rank-1;

  if ( my_buddy < Ntasks )
    {

      #define FIRST_ROUND 0
      #define SECOND_ROUND 1
      
      if ( Im_even )
	{
	  int        buddy_rank;
	  MPI_Status status;

	  MPI_Send( &Rank, 1, MPI_INT, my_buddy, FIRST_ROUND, MPI_COMM_WORLD );
	  MPI_Recv( &buddy_rank, 1, MPI_INT, my_buddy, SECOND_ROUND, MPI_COMM_WORLD, &status );
	  

	  if ( buddy_rank == my_buddy )
	    printf("\tRank %d says: I confirm I have received a reply from my buddy\n", Rank);
	  else
	    printf("oops, a stranger has replied to me\n");	  
	}
      else
	{
	  int        buddy_rank;
	  MPI_Status status;

	  MPI_Recv( &buddy_rank, 1, MPI_INT, my_buddy, FIRST_ROUND, MPI_COMM_WORLD, &status );
	  MPI_Send( &Rank, 1, MPI_INT, my_buddy, SECOND_ROUND, MPI_COMM_WORLD );
	  

	  if ( buddy_rank == my_buddy )
	    printf("Rank %d says: I confirm I have received the message from my buddy\n", Rank);
	  else
	    printf("oops, a stranger has communicated with me\n");	  
	}
      
    }
  else
    printf("Rank %d has got nobody to talk with\n", Rank );
    

  MPI_Finalize();

  return 0;
}
```

!!! note "Exercise"

    Changing the order of the send and receive operations and using `MPI_Ssend`, try to create a deadlock in the code above.
    When `MPI_Ssend` is used, the *rendez-vous* protocol is enforced, so it will not return until the target process that is being sent the information is ready to receive the data.
    If both processes send at the same time and wait for the other to receive, they will just get stuck.

### Computing pi

The following code computes the value of pi with a MPI-parallelized Monte Carlo sampling.
It is incomplete: you need to fill out some sections to make it work.
After that, measure the parallel speedup obtained when changing the number of MPI processes (hint: `mpirun -n <number of processes> a.out`).

```c title="calculate_pi_incomplete.c"
/* ················································
 *
 *  This example is provided in the frame of the
 *  course "Introduction to HPC" at University
 *  of Trieste, 2024-2025.
 *
 *  This code calculates the value of pi greek by
 *  throwing N dice in the first quadrant of the
 *  circle of radius 1, and counting how many fall
 *  within distance_from_origin = 1.
 *
 *  Check the examples calculate_pi.collectives.c,
 *  calculate_pi.producer_consumer.c and
 *  calculate_pi.producer_consumer.threads.c for
 *  different implementations
 *
 *  DISCLAIMER : the code is correct as for the
 *               MPI parallelization (purposely, no
 *               collectives are used) but contains
 *               a simple bug.
 *               Exdercise: find and fix it
 *
 *
 *  luca.tornatore@inaf.it
 *
 * ················································ */



#if defined(__STDC__) 
#  if (__STDC_VERSION__ >= 199901L)
#     define _XOPEN_SOURCE 700
#  endif
#endif 
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <omp.h>
#include <mpi.h>

#define TCPU ({struct timespec ts; (clock_gettime( CLOCK_PROCESS_CPUTIME_ID, &ts ), (double)ts.tv_sec + \
                                    (double)ts.tv_nsec * 1e-9);})

#define TtCPU ({struct timespec ts; (clock_gettime( CLOCK_THREAD_CPUTIME_ID, &ts ), (double)ts.tv_sec + \
				     (double)ts.tv_nsec * 1e-9);})

int main( int argc, char **argv )
{
  /* initialize MPI */
  int provided;
  MPI_Init_thread(&argc, &argv, MPI_THREAD_SINGLE, &provided);
  
  if ( provided < MPI_THREAD_SINGLE )
    {
      // manage the failure with some message
      // ...
      //
      MPI_Abort(MPI_COMM_WORLD, 1);
    }

  int Myrank, Ntasks;
  MPI_Comm myCOMM_WORLD;
  
  MPI_Comm_dup ( MPI_COMM_WORLD, &myCOMM_WORLD );
  MPI_Comm_size( myCOMM_WORLD, &Ntasks );
  MPI_Comm_rank( myCOMM_WORLD, &Myrank );

  /* initialize the problem */

  // init the psuedo-random generator
  srand48( Myrank + time(NULL) );

  // get how many shots in total
  unsigned int N = ( argc > 1 ? atoi(*(argv+1)) : 1000000 );
  // translate in how many shots per thread
  N = (N / Ntasks) + (N % Ntasks > 0);

  /* throw the dice and count the inner points */
  
  unsigned int inner_points = 0;
  for ( unsigned int i = 0; i < N; i++ )
    {
      double x = drand48();
      double y = drand48();

      inner_points += ( (x*x + y*y) < 1.0 );
    }

  
  if ( Myrank == 0 )
    /* collect the partial results */
    {
      unsigned long long all_inner_points = 0; 
      for ( int t = 0; t < Ntasks-1; t++ )
	/* get the result of every single MPI tasks */
	{
	  // ... fill the gap
	}

      printf ( "pi greek estimate out of %llu points is: %g\n", ... );
    }
  else
    /* send the partial result */
    // fill the gap
    ...

  
  MPI_Finalize();
  return 0;
}
```
