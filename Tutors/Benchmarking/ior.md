---
icon: material/nas
---

# IOR  Input/Output Benchmark

One of the most hot-topic which is gaining more and more attention in the HPC and AI community is the performance of the storage system, since in many occasions it can be the bottleneck of the whole system. 

Benchmarking the storage system [is not an easy task](https://www.usenix.org/legacy/event/hotos11/tech/final_files/Tarasov.pdf), since many factors can affect the performance and pollute the results (e.g., network, cacheing effects, etc.).

One of the most widely used tools for benchmarking the storage system is [IOR benchmark](https://ior.readthedocs.io/en/latest/userDoc/tutorial.html). 
This tool allow to mimic the most common access patterns (e.g., sequential, random, etc.) and to test the performance of the storage system under different conditions (e.g., different block sizes, different number of processes, serial/random access, etc.).

# Step 0: Install IOR

Download the source code from the [IOR GitHub repository](github.com/hpc/ior):

```bash
tag=4.0.0
url=https://github.com/hpc/ior.git

mkdir -p $HOME/src ; cd $HOME/src
git clone --depth=1 $url -b $tag --single-branch ior
cd ior
```

Request the resources, load the MPI module (needed for the dependencies) and compile the code:

```bash
salloc -p GENOA -A lade --cpus-per-task=8 --tasks-per-node=1 --mem=10G --time=00:10:00
module load openMPI/5.0.5
srun ./bootstrap
srun ./configure --with-mpiio --with-posix CC=mpicc
srun make -j 8
srun  make install prefix=${HOME}/.local/ior/4.0.0
```

This will install the IOR binary in `${HOME}/.local/ior/4.0.0/bin/ior`. 
You can add this path to your `PATH` variable to be able to run the `ior` command from anywhere.

# Step 1: Run the benchmark

Before to run the benchmark, take a look at the [IOR documentation](https://ior.readthedocs.io/en/latest/userDoc/options.html) to understand all the different options available.

Some notable options are:

- `-a <api>`: specify the API to use (e.g., POSIX, MPI-IO, etc.)
- `-t <transferSize>`: specify the size of each data transfer (i.e., write/read a file in chunks of this size)
- `-b <blockSize>`: specify the size of the block to be written/read (i.e., the size of the file to be written/read)
- `-z`: access the file in a random way (instead of sequential)
- `-i <numberOfIterations>`: specify the number of iterations to run the benchmark
- `-o <fileName>`: specify the complete file name to be written/read. Note that accordingly to the path specified, the file will be written/read in a different location (e.g., scratch, fast) which can have a big impact on the performance.
- `-F`: let each process write/read to a different file, instead of all processes writing/reading to the same file.
- `-r`, `-w`: specify if the benchmark should be run in read or write mode (or both)


***Examples***

First of all, let's request some resources and load the MPI module:

```bash
alias runior="srun -p GENOA --cpus-per-task=1 --tasks-per-node=16 --mem=120G --time=01:00:00 ior"
module load openMPI/5.0.5
# Add the IOR binary to the PATH variable
export PATH=${HOME}/.local/ior/4.0.0/bin:$PATH
```

1. Run a sequential write benchmark using POSIX API, writing a file of 1GB in chunks of 4MB, with 16 processes, in the scratch storage:

```bash

runior \
 -a POSIX \
 -t 4M \
 -b 1G \
 -w -r \
 -o /orfeo/cephfs/scratch/<your_group>/<your_user>/ior_test_file
```

```
access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     3154.55    788.75     0.018848    1048576    4096       0.000812   5.19       0.367754   5.19       0
read      119139     29791      0.000331    1048576    4096       0.000094   0.137492   0.052599   0.137520   0
```

This are not so realistic results, have a look at the read which seems ot be almost 120GB/s!. This is because of the cacheing effects, since the file is written and read in a very short time, the read operation is served from the cache and not from the storage system.

Let's try to add the following otpions:

- `-e` impose a `fsync` call after each write operation, to force the data to be written to the storage system and not to be served from the cache
- `-O useO_DIRECT=1` use the `O_DIRECT` flag to bypass the cache and write/read directly to/from the storage system

And, another common trick to avoid the cacheing effects is to increase the size of the file to be written:


```bash
runior \
 -a POSIX \
 -t 4M \
 -b 10G \
 -w -r \
 -e \
  -O useO_DIRECT=1 \
 -o /orfeo/cephfs/scratch/<your_group>/<your_user>/ior_test_file
```

```
access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     1092.10    273.02     0.055986    10485760   4096       0.000287   150.02     12.93      150.02     0
read      801.40     200.35     0.078564    10485760   4096       0.000083   204.44     12.90      204.44     0
```

or switching to the `MPIIO` API:

```bash
runior \
 -a MPIIO \
 -t 4M \
 -b 10G \
 -w -r \
 -e \
  -O useO_DIRECT=1 \
 -o /orfeo/cephfs/scratch/<your_group>/<your_user>/ior_test_file
```
```
access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     1452.95    402.00     0.039801    10485760   4096       0.006501   101.89     10.87      112.76     0
read      2011.94    503.03     0.030892    10485760   4096       0.004917   81.43      7.50       81.43      0
```

What a huge difference!

Now let's try to see what happens if we write/read a file in the fast storace, which is a NVMe-based storage system and should provide much higher performance:

```bash
runior \
 -a MPIIO \
 -t 4M \
 -b 10G \
 -w -r \
 -e \
 -O useO_DIRECT=1 \
 -o /orfeo/cephfs/fast/<your_group>/<your_user>/ior_test_file
```

```

access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     4059       1034.65    0.015083    10485760   4096       0.013134   39.59      7.28       40.36      0
read      6608       1652.28    0.009170    10485760   4096       0.006305   24.79      1.88       24.79      0
```

From this test we can see that the performance of the fast storage is much higher than the scratch storage, both in write and read operations.
In any casem all the test presented here are just examples, with a very low number of processes which is not representative of a real HPC workload.


!!! abstract "Exercise"
    Try to run the bechmark with different options and see how they affect the performance!

---
<br>
Authors: Isac Pasianotto, Stefano Cozzini

