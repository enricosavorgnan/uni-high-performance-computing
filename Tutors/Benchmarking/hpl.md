---
icon: material/flash
---

# HPL: High Performance Linpack

The [High Performance Linpack (HPL)](https://www.netlib.org/benchmark/hpl/) is a widely used benchmark for measuring the performance of supercomputers.

HPL solves a dense system of linear equations using LU decomposition with partial pivoting and reports the performance in terms of floating-point operations per second (FLOPS).

!!! note "FLOPS: a definition"
    ***FLOPS*** is a measure of computer performance, especially in fields of scientific calculations that require floating-point calculations. It stands for "Floating Point Operations Per Second" and indicates how many floating-point calculations in double precision a computer can perform in one second.  Naturally *the higher the FLOPS, the better the performance* of the system.


!!! tip "HPL: current relevance"
    HPL is the benchmark used to rank supercomputers in the [TOP500 list](https://www.top500.org/), which is the ranking of the 500 most powerful supercomputers in the world


In this tutorial, we will see how to run HPL on a single node and try to assess its performance


## Step 0: Compile the benchmark

The first step is to download the HPL source code. 

```bash
mkdir -p $HOME/src ; cd $HOME/src
wget -q https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
tar -xzvf hpl-2.3.tar.gz
cd hpl-2.3
```

For this exercitation we will use the `GENOA` partition.
To compile the benchmark, we need to create a `Makefile` that specifies the compiler and the libraries to link against.

We used the `setup/Make.Linux_PII_CBLAS` file as template:

```bash
cp setup/Make.Linux_PII_CBLAS Make.epyc
```

Then edit the `Makefile.epyc` file with the following content:

<details>
<summary>Makefile.epyc modifications</summary>
```diff
 # - Platform identifier ------------------------------------------------
 # ----------------------------------------------------------------------
 #
-ARCH         = Linux_PII_CBLAS
+ARCH         = epyc
 #
 # ----------------------------------------------------------------------
 # - HPL Directory Structure / HPL library ------------------------------
 # ----------------------------------------------------------------------
 #
-TOPdir       = $(HOME)/hpl
+TOPdir       = $(HOME)/src/hpl-2.3
 INCdir       = $(TOPdir)/include
 BINdir       = $(TOPdir)/bin/$(ARCH)
 LIBdir       = $(TOPdir)/lib/$(ARCH)
@@ -81,9 +81,9 @@
 # header files,  MPlib  is defined  to be the name of  the library to be
 # used. The variable MPdir is only used for defining MPinc and MPlib.
 #
-MPdir        = /usr/local/mpi
-MPinc        = -I$(MPdir)/include
-MPlib        = $(MPdir)/lib/libmpich.a
+MPdir        =
+MPinc        = -I$(MPI_INCLUDE)
+MPlib        = $(MPI_LIB)/libmpi.so
 #
 # ----------------------------------------------------------------------
 # - Linear Algebra library (BLAS or VSIPL) -----------------------------
@@ -92,9 +92,9 @@
 # header files,  LAlib  is defined  to be the name of  the library to be
 # used. The variable LAdir is only used for defining LAinc and LAlib.
 #
-LAdir        = $(HOME)/netlib/ARCHIVES/Linux_PII
-LAinc        =
-LAlib        = $(LAdir)/libcblas.a $(LAdir)/libatlas.a
+LAdir        =
+LAinc        = -I$(OPENBLAS_INCLUDE)
+LAlib        = $(OPENBLAS_LIB)/libopenblas.a
 #
 # ----------------------------------------------------------------------
 # - F77 / C interface --------------------------------------------------
@@ -166,14 +166,14 @@
 # - Compilers / linkers - Optimization flags ---------------------------
 # ----------------------------------------------------------------------
 #
-CC           = /usr/bin/gcc
+CC           = mpicc
 CCNOOPT      = $(HPL_DEFS)
-CCFLAGS      = $(HPL_DEFS) -fomit-frame-pointer -O3 -funroll-loops
+CCFLAGS      = $(HPL_DEFS) -fomit-frame-pointer -O3 -funroll-loops -fopenmp
 #
 # On some platforms,  it is necessary  to use the Fortran linker to find
 # the Fortran internals used in the BLAS library.
 #
-LINKER       = /usr/bin/g77
+LINKER       = mpicc
 LINKFLAGS    = $(CCFLAGS)
 #
 ARCHIVER     = ar
```
</details>


Now we are ready to compile the benchmark. **Before compiling**
make sure to: 

- Request an interactive session on the `GENOA` and not perform the compilation (which can be a demanding task) on the login node
- Load the `OpenBLAS` and `OpenMPI` modules, which are required for the compilation


```bash
salloc -n 1 -N1 -p GENOA --time=1:0:0 --mem=490G
module load openMPI/5.0.5
module load openBLAS/0.3.29-omp
```

And compile with: (this can take a while, so be patient)

```bash
srun -n1 make arch=epyc
```
which will create the `xhpl` executable in the `bin/epyc` directory.


## Step 1: Run the benchmark

Now that the benchmark is compiled, we can run it.
To do so, we can use a simple `sbatch` script like the following one:

```bash
#!/bin/bash
#SBATCH --partition=GENOA
#SBATCH --job-name=HPL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node 64
#SBATCH --mem=490G
#SBATCH --time=02:00:00


# --- general vars ---
export codedir=${HOME}/src/hpl-2.3/bin/epyc
#   -> todo: edit this path according to your file <-
export datfile=${HOME}/intro-to-hpc/hpl/HPL.dat

# set numeber of process equals to numer of tasks
export nproc=64
export mapping=core

# --- load the modules ---
module load openMPI/5.0.5
module load openBLAS/0.3.29-omp

# --- launch the job ---

# update hte HPL.dat file
mv ${datfile} ${codedir}/HPL.dat
mpirun -np ${nproc} --map-by ${mapping} $codedir/xhpl
```

As you can see, there is a variable `datfile` that points to the `HPL.dat` file, which is the input file for the benchmark.

This is extremely important, as the `HPL.dat` file contains all the parameters for the benchmark, such as the size of the matrix to be solved, the block size, and the number of processes to be used. The exhaustive description of the parameters can be found in the [HPL documentation](https://netlib.org/benchmark/hpl/tuning.html).

!!! tip "HPL.dat: starting point"
    A good starting point for the `HPL.dat` is [this website](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/) which provides some guidelines on how to set the parameters for the benchmark.


!!! Exercise "Run the benchmark"
    Run the benchmark with the provided `HPL.dat` file and try to understand the output.

    Try to reach as many GFLOPS as possible by tuning the parameters in the `HPL.dat` file.


<details>
<summary>Example of a BAD HPL.dat file</summary>
```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
6912         Ns
1            # of NBs
192           NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
8            Ps
8            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
1            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
1            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
##### This line (no. 32) is ignored (it serves as a separator). ######
0                               Number of additional problem sizes for PTRANS
1200 10000 30000                values of N
0                               number of additional blocking sizes for PTRANS
40 9 8 13 13 20 16 32 64        values of NB
```

```
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR11C2R4        6912   192     8     8               0.23             9.5058e+02
```
</details>

### Step 1.2: Some very impactful parameters

- `N`: ***Problem size***: the size of the matrix to be solved. 

    This can impact significantly the performance of the benchmark, as it can affect the amount of parallelism that can be exploited.
    
    - If `N` is too big, it will not fit in memory, the system will use the swap memory, which is much slower than the RAM, and the performance will drop.
    - If `N` is too small, it will not be able to exploit the parallelism of the system because there is not enough work to be done, and the number of flop to perform will be too small to amortize the communication overhead
    - As a rule of thumb, a good value for `N` is around 80% of the available memory

- `NB`: ***Block size***: the size of the blocks into which the matrix is divided. 

    - If `NB` is too small, almost no data reuse will be possible at the highest levels of the memory hierarchy, dropping the performance. Moreover, lowering the block size will increase the communication as more blocks will be exchanged between the processes.
    - If `NB` is too big, the performance will drop the system will not be able to fully exploit the cache.
    - Usually we want to have small values of `NB` (but not too small).

- `P` and `Q`: ***Grid shape***: the shape of the process grid. 
  
    Are the number of processes in the row and column direction, respectively.
    - The numper of MPI process must be `>=P*Q` to avoid flat grid
    
<details>
<summary>Example of a better HPL.dat files</summary>

<details>
<summary> MPI-only version</summary>
```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
231424       Ns
1            # of NBs
256          NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
8            Ps
8            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
3            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
2            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
##### This line (no. 32) is ignored (it serves as a separator). ######
0                               Number of additional problem sizes for PTRANS
1200 10000 30000                values of N
0                               number of additional blocking sizes for PTRANS
40 9 8 13 13 20 16 32 64        values of NB
```
Launched with:
```bash
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

mpirun -np 64 \
  --bind-to core --map-by core --report-bindings \
  ${codedir}/xhpl
```
```
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR23C2R4      110592   256     8     8             265.94             3.3908e+03
```

</details>

<details>
<summary> MPI+OpenMP version</summary>
```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
110592       Ns
1            # of NBs
256          NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
4            Ps
4            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
3            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
2            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
##### This line (no. 32) is ignored (it serves as a separator). ######
0                               Number of additional problem sizes for PTRANS
1200 10000 30000                values of N
0                               number of additional blocking sizes for PTRANS
40 9 8 13 13 20 16 32 64        values of NB
```
Launched with:
```bash
export OMP_NUM_THREADS=4
export OMP_PROC_BIND=close
export OMP_PLACES=cores
export OPENBLAS_NUM_THREADS=4

mpirun -np 16 \
  --bind-to core --map-by ppr:8:socket:PE=4 --report-bindings \
  ${codedir}/xhpl
```
```

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR23C2R4      110592   256     4     4             285.58             3.1576e+03
```
</details>
</details>


## Are we doing good? Theoretical peak performance

TODO better this part

$$
FLOPS = n_{\text{cores}} \times \text{max}\_\text{frequency} \times \text{FLOPS per cycle}
$$

In the case of the `GENOA` partition, is equipped with 2 sockets equipped with [AMD EPYC 9374F 32-Core CPUs](https://www.amd.com/en/products/processors/server/epyc/4th-generation-9004-and-8004-series/amd-epyc-9374f.html), so we have:

- $n_{\text{cores}} = 2\times 32 = 64$
- $\text{max}\_\text{frequency} = 4.1 \text{GHz}$
- $\text{FLOPS per cycle}$ = [16](https://www.amd.com/en/blogs/2025/leadership-hpc-performance-with-5th-generation-amd.html?utm_source=chatgpt.com) 

which gives us a theoretical peak performance of:

$$
FLOPS = 64 \times 4.1 \text{GHz} \times 16 = 4.1984 \text{TFLOPS}
$$


We have achieved a performance which is roughly around 81% of the theoretical peak performance, which is a decent result, considering that the theoretical peak performance is an upper bound that is very difficult to achieve.
In practice the performance of the benchmark can be affected by many factors and doing a very fine tuning of the parameters in the `HPL.dat`  can lead to a significant improvement (e.g 90%).


## Step 2: Run the benchmark on multiple nodes

You can try to run the benchmark on multiple nodes by changing the `#SBATCH` directives in the `sbatch` script and by updating accordingly the parameters in the `HPL.dat` file.

Ideally doubling the computational power (i.e. doubling the number of nodes) should lead to a doubling of the performance, but in practice this is very difficult to achieve due to the communication overhead between the nodes and the fact that the benchmark is not perfectly scalable.


```
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR23C2R4      139264   256    16     8             307.31             5.8595e+03
```



<br>
Authors: Isac Pasianotto, Niccolò Tosato, Stefano Cozzini
