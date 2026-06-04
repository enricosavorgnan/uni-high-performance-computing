---
icon: material/code-braces
---

# Code benchmarking

## Concepts introduction

In this section we will see how to quantitative assess the goodnes of a parallel code.
This evaluation is based on one of the most important concepts in HPC: the **scalability**. 

In a nutshell, the *"scalability"* indicates how well a parallel code can take advantage of all the resourses used to run it.

We distinguish between two types of scalability:

!!! info "Strong scalability"
    - In ***strong scalability***, we keep the **problem size fixed** and we increase the number of resources (e.g. cores, nodes, etc.) used to solve the problem.
    - Ideally, if a code has perfect strong scalability, the execution time should decrease proportionally to the increase in resources. For example, if we double the number of cores, the execution time should be halved.
    - In practice, due to factors such as communication overhead, load imbalance, and the nature of the problem being solved, achieving perfect strong scalability is often difficult. As we increase the number of resources, the efficiency of the code may decrease, leading to diminishing returns in performance.
  
!!! info "Weak scalability"
    - In ***weak scalability***, we increase the problem size proportionally to the increase in resources, such that each working unit (e.g. core, node, etc.) has the same amount of work to do regardless of the number of resources used.
    - Ideally, if a code has perfect weak scalability, the execution time should remain constant as we increase both the problem size and the number of resources. For example, if we double the number of cores and also double the problem size, the execution time should remain the same.
    - Weak scalability is often measured in term of FLOPS. In this sense, if a code has perfect weak scalability, the FLOPS should increase proportionally to the increase in resources. For example, if we double the number of cores, the FLOPS should also double.


It also important to define the two main metrics used to evaluate the scalability of a code:

- ***Speedup***: the ratio of the execution time of the code on a single resource (e.g. core, node, etc.) to the execution time on multiple resources. 

For a given problem size $n$ 

$$
S(p, n) = \frac{T_s(n)}{T_p(n)}
$$ 

where $T_s$ *(Serial)* is the execution time on a single resource and $T_p$ *(Parallel)* is the execution time on multiple resources.

- ***Efficiency***: the ratio of the speedup to the number of resources used. It is defined as

$$
Eff(p, n) = \frac{S(p, n)}{p} = \frac{T_s(n)}{p \cdot T_p(n)}
$$


## Examples

### 1. Strong scalability example:

We are going to use the following code, which will perform a matrix-matrix multiplications relying on the `openBLASz library:

<details>
<summary> Code used for the matrix multiplication</summary>

```c
cat main.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
// - use the blas library
#include "cblas.h"


// ------ Standard definitions
#define DTYPE double
// - Adjust it if another datatype is used!
#define GEMMCPU cblas_dgemm

// ----- Time clock setup
struct timespec diff(struct timespec start, struct timespec end)
{
        struct timespec temp;
        if ((end.tv_nsec-start.tv_nsec)<0) {
                temp.tv_sec = end.tv_sec-start.tv_sec-1;
                temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
        } else {
                temp.tv_sec = end.tv_sec-start.tv_sec;
                temp.tv_nsec = end.tv_nsec-start.tv_nsec;
        }
        return temp;
}

// ----- main loop
int main(int argc, char** argv)
{
    DTYPE *A, *B, *C;
    int m, n, k, i, j;
    DTYPE alpha, beta;
    struct timespec begin, end;
    double elapsed;
    // - set default arguments
    if (argc == 1)
    {
    m = 2000, k = 200, n = 1000;
    }
    else if (argc == 4)
    {
        m = atoi(argv[1]);
        k = atoi(argv[2]);
        n = atoi(argv[3]);
    }
    else
    {
    printf( "Usage: %s M K N, the corresponding matrices will be  A(M,K) B(K,N) \n", argv[0]);
    return 0;
    }


    //printf (" Initializing data for matrix multiplication C=A*B for matrix \n"
    //        " A(%ix%i) and matrix B(%ix%i)\n\n", m, k, k, n);
    alpha = 1.0; beta = 0.0;

    // - Allocate the matrices
    A = (DTYPE *)malloc( m*k*sizeof( DTYPE ));
    B = (DTYPE *)malloc( k*n*sizeof( DTYPE ));
    C = (DTYPE *)malloc( m*n*sizeof( DTYPE ));
    if (A == NULL || B == NULL || C == NULL) {
      printf( "\n ERROR: Can't allocate memory for matrices. Aborting... \n\n");
      free(A);
      free(B);
      free(C);
      return 1;
    }

    // -- initialize the matrices
    for (i = 0; i < (m*k); i++) {
        A[i] = (DTYPE)(i+1);
    }

    for (i = 0; i < (k*n); i++) {
        B[i] = (DTYPE)(-i-1);
    }

    for (i = 0; i < (m*n); i++) {
        C[i] = 0.0;
    }

    sleep(1);
    //printf (" Computing matrix product using gemm function via CBLAS interface \n");
    // -- start the clock, do the product, stop the clock
    clock_gettime(CLOCK_MONOTONIC, &begin);
    GEMMCPU(CblasColMajor, CblasNoTrans, CblasNoTrans,
                m, n, k, alpha, A, m, B, k, beta, C, m);
    clock_gettime(CLOCK_MONOTONIC, &end);
    // -- print the results
    elapsed = (double)diff(begin,end).tv_sec + (double)diff(begin,end).tv_nsec / 1000000000.0;
    double gflops = 2.0 * m *n*k;
    gflops = gflops/elapsed*1.0e-9;

    printf("\n Elapsed time: %lf\n Gflops: %lf\n", elapsed, gflops);

    // ------ Release the allocated memory
    free(A);
    free(B);
    free(C);
    return 0;
}
```
</details>

Due to time constraints, we will not measure the code execution for every single core, and we will just run the code once. Remember that usually to have a good estimation of the scalability of a code, it is important to run the code multiple times for each number of cores and then make some statistics on the results (e.g. average, median, etc.).

<details>
<summary> Summission script</summary>
```bash
#!/bin/bash
#SBATCH --partition=GENOA
#SBATCH --job-name=dgemm
#SBATCH --account=lade
#SBATCH --nodes=1
#SBATCH --ntasks-per-node 64
#SBATCH --mem=490G
#SBATCH --time=02:00:00


# -- Load modules
module load openBLAS/0.3.29-omp
module load openMPI/5.0.5

# -- compile the code:
rm main.x
gcc main.c -lopenblas  -fopenmp -O3 -o main.x

export OMP_PLACES=cores
export OMP_PROC_BIND=close
export PROB_SIZE=25000

# -- strong scalability

for ncore in 64 32 16 8 4 2 1
do
    echo "----- performing the run with ${ncore} cores"
    export OMP_NUM_THREADS=${ncore}
    ./main.x ${PROB_SIZE} ${PROB_SIZE} ${PROB_SIZE}
done
```
</details>

The obtained results are the following:

<div style="display:flex; gap:2rem; flex-wrap:wrap; align-items:stretch;">

  <div style="flex:1; min-width:320px;">
    <table>
      <thead>
        <tr>
          <th style="text-align:right;">cores</th>
          <th style="text-align:right;">time</th>
          <th style="text-align:right;">speedup</th>
          <th style="text-align:right;">efficiency</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="text-align:right;">1</td><td style="text-align:right;">472.547</td><td style="text-align:right;">1</td><td style="text-align:right;">1</td></tr>
        <tr><td style="text-align:right;">2</td><td style="text-align:right;">236.899</td><td style="text-align:right;">1.99472</td><td style="text-align:right;">0.99736</td></tr>
        <tr><td style="text-align:right;">4</td><td style="text-align:right;">118.047</td><td style="text-align:right;">4.00304</td><td style="text-align:right;">1.00076</td></tr>
        <tr><td style="text-align:right;">8</td><td style="text-align:right;">59.0418</td><td style="text-align:right;">8.0036</td><td style="text-align:right;">1.00045</td></tr>
        <tr><td style="text-align:right;">16</td><td style="text-align:right;">29.8229</td><td style="text-align:right;">15.8451</td><td style="text-align:right;">0.990319</td></tr>
        <tr><td style="text-align:right;">32</td><td style="text-align:right;">15.8793</td><td style="text-align:right;">29.7587</td><td style="text-align:right;">0.92996</td></tr>
        <tr><td style="text-align:right;">64</td><td style="text-align:right;">12.216</td><td style="text-align:right;">38.6826</td><td style="text-align:right;">0.604416</td></tr>
      </tbody>
    </table>
  </div>

  <div style="flex:1; min-width:320px;">
    <img src="/Benchmarking/img/strong-scaling-example.png"
     alt="Strong scaling example"
     style="max-width:100%; height:auto;">
  </div>

</div>

The intresting aspect is how the code scales pratically perfectly up to 32 cores, while the efficiency drops significantly when we use 64 cores. This is due to the fact that we setted `OMP_PROC_BIND=close`, which means that the threads will be binded to the closest cores. In this way, when we use 64 cores, we are using all the cores of the node, i.e. 2 sockets, making threads communication less effective due to the NUMA effect. 

### 2. Weak scalability example:

We are going to use the same code as before, but in this case we will increase the problem size proportionally to the number of cores used.

Since we are multiplying two square matrices, considering $N$ the size of the matrix, the problem size is $N^3$.

Let's fix the problem size for 1 core to be $N=10,000$, hence we can define for the number of cores $p$ the problem size as:

$$
N(p) = \lfloor 10,000 \cdot \sqrt[3]{p} \rfloor
$$

<details>
<summary> Summission script</summary>
```bash
#!/bin/bash
#SBATCH --partition=GENOA
#SBATCH --job-name=dgemm
#SBATCH --account=lade
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --mem=490G
#SBATCH --time=02:00:00

# -- Load modules
module load openBLAS/0.3.29-omp
module load openMPI/5.0.5

# -- compile the code:
rm -f main.x
gcc main.c -lopenblas -fopenmp -O3 -o main.x

export OMP_PLACES=cores
export OMP_PROC_BIND=spread

ncores=(1 2 4 8 16 32 64)
sizes=(10000 12600 15900 20000 25200 31700 40000)

for i in "${!ncores[@]}"; do
  ncore="${ncores[$i]}"
  size="${sizes[$i]}"

  echo "----- executing the run with ${ncore} cores and problem size ${size}"

  export OMP_NUM_THREADS="${ncore}"
  ./main.x "${size}" "${size}" "${size}"
done
```
</details>

The obtained results are the following:

## Weak scaling results

The obtained results are the following:

<div style="display:flex; gap:2rem; flex-wrap:wrap; align-items:stretch;">

  <!-- TABLE COLUMN -->
  <div style="flex:1; min-width:320px;">

    <table>
      <thead>
        <tr>
          <th style="text-align:right;">cores</th>
          <th style="text-align:right;">time</th>
          <th style="text-align:right;">gflops</th>
          <th style="text-align:right;">efficiency</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="text-align:right;">1</td>
          <td style="text-align:right;">30.1324</td>
          <td style="text-align:right;">66.3737</td>
          <td style="text-align:right;">1</td>
        </tr>
        <tr>
          <td style="text-align:right;">2</td>
          <td style="text-align:right;">32.6637</td>
          <td style="text-align:right;">122.483</td>
          <td style="text-align:right;">0.922679</td>
        </tr>
        <tr>
          <td style="text-align:right;">4</td>
          <td style="text-align:right;">31.8184</td>
          <td style="text-align:right;">252.664</td>
          <td style="text-align:right;">0.951671</td>
        </tr>
        <tr>
          <td style="text-align:right;">8</td>
          <td style="text-align:right;">30.9811</td>
          <td style="text-align:right;">516.444</td>
          <td style="text-align:right;">0.972607</td>
        </tr>
        <tr>
          <td style="text-align:right;">16</td>
          <td style="text-align:right;">30.781</td>
          <td style="text-align:right;">1039.8</td>
          <td style="text-align:right;">0.979112</td>
        </tr>
        <tr>
          <td style="text-align:right;">32</td>
          <td style="text-align:right;">31.2319</td>
          <td style="text-align:right;">2039.9</td>
          <td style="text-align:right;">0.960425</td>
        </tr>
        <tr>
          <td style="text-align:right;">64</td>
          <td style="text-align:right;">40.7526</td>
          <td style="text-align:right;">3140.9</td>
          <td style="text-align:right;">0.739398</td>
        </tr>
      </tbody>
    </table>

  </div>

  <!-- IMAGE COLUMN -->
  <div style="flex:1; min-width:320px; display:flex; justify-content:center; align-items:center;">
    <img src="/Benchmarking/img/weak-scaling-example.png"
         alt="Weak scaling example"
         style="max-width:100%; height:auto;">
  </div>

</div>


!!! tip "An important observation"
    In this examples we focused on the scalability with `OpenMP`, allocating every time an entire node and using `OMP_NUM_THREADS` to set the number of cores used. 

    However, we can do the same kind of analysis in a multi-node scenario, properly parallelizing the code with `MPI` and using `mpirun`. Usually in this second case it is common to place one MPI process per node and then use `OpenMP` to parallelize the code within each node.

<br>
Authors: Isac Pasianotto, Niccolò Tosato, Stefano Cozzini
