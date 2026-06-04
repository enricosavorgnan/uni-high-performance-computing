---
icon: material/network
---

# OSU Micro-Benchmarks

One of the well known performance killer in modern HPC applications is the communication between the nodes, which can be very expensive in terms of time and can significantly affect the performance of the application.

For this reason it is important to have a precise idea of what the used system is capable of in terms of communication performance, and to have a tool to measure it.

The [OSU Micro-Benchmarks suite](https://mvapich.cse.ohio-state.edu/benchmarks/) is a collection of MPI-based code which  can be used to measure the communication performance of a system, and to have a precise idea of the communication performance of the system, in terms of latency and bandwidth.

!!! note "Latency and Bandwidth"
    - **Latency**: the time it takes to send a message from one node to another, measured in microseconds (µs).
    - **Bandwidth**: the amount of data that can be sent from one node to another in a given time, measured in Megabytes per second (MB/s).

## Step 0: Install the OSU Micro-Benchmarks suite

Download the code from the [official website](https://mvapich.cse.ohio-state.edu/benchmarks/) and follow the instructions to install it on your system.

```bash
version=7.5.2
url="http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-$version.tar.gz"

mkdir -p $HOME/src/ ; cd $HOME/src/
wget -q $url
tar -xzf osu-micro-benchmarks-$version.tar.gz

#   --> edit this for your user case <--
outdir=$HOME/intro-to-hpc/osu/bin
mkdir -p $outdir
```

Now you can request the resource and compile the code:

```bash
salloc -p GENOA -A lade --cpus-per-task=4 --tasks-per-node=1 --mem=10G --time=00:10:00
module load openMPI/5.0.5
srun -n1 ./configure CC=mpicc CXX=mpicxx --prefix=$outdir
srun make -j 4
srun make install
```

This will install in your `$outdir`  a path `/libexec/osu-micro-benchmarks/mpi` where you can find the compiled code.

```
ipasia00@login01:~/intro-to-hpc/osu/bin/libexec/osu-micro-benchmarks/mpi$ ls ${outdir}/libexec/osu-micro-benchmarks/mpi/
collective  congestion  one-sided  pt2pt  startup
```

This folders contains the different benchmarks, categorized in different types of communication patterns allowed by the MPI interface.

## Step 1: Undertand what we are measuring

!!! tip "pt2pt benchmarks"
    In this lecture we will focus on the `pt2pt` benchmarks, which are the ones that measure the point-to-point communication performance of the system, which is the most common communication pattern in HPC applications.

    This family of benchmarks include the so-called ***"ping-pong"*** benchmarks, which consist in sending a messages from one node to another and then back, measuring the time it takes for the round trip, usually varying the size of the message itself.


With this *Ping-Pong* benchmark we can have hints about the two most important metrics of the communication performance of the system: 

- ***Latency***: measuring the time it takes to send a message from one node. 
  - With **smaller size message**, up to a certanin threshold, the latency will be the dominant factor in the communication performanc. This means that the time it takes to send a message will be mostly determined by the time it takes to establish the communication between the nodes, and not by the size of the message itself.
- ***Bandwidth***: measuring the amount of data that can be sent from one node to another in a given time. In this family of benchmark, the code will try to send as many messages as possible in a given time, counting the total amount of data sent to calculate the bandwidth.
  - with smaller size message, the phisical bandwith of the system can not be exploited properly because of the overhead of the communication.
  - As son as the **size of message grows**, the measured bandwith will reach a plateau, which is the maximum bandwith of the system, and the latency will become less and less important in the communication performance.

## Step 2: Run the benchmarks

As said before, the `pt2pt` benchmarks will require *exactly* two processes to run, so we will spawn 2 processes.  In this case, the computational resources are not the bottleneck, so even a couple of cores and a small amount of memory will be enough to run the benchmarks.
However, we will request the entire node with the `--exclusive` flag, to avoid any interference with other users (which can be very noisy) and to have a more accurate measurement of the communication performance of the system.
!!! tip "Read the docs!"
    The exaustive documentation of what each code does, and which parameters it accepts, is available in the [official website](https://mvapich.cse.ohio-state.edu/static/media/mvapich/README-OMB.txt). 

<details>
<summary>Example of a ping-pong benchmark</summary>

<details>
<summary>On the same node</summary>

```bash
#!/bin/bash
#SBATCH --no-requeue
#SBATCH --job-name="osu"
#SBATCH --get-user-env
#SBATCH --account=lade
#SBATCH --partition=GENOA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=12
#SBATCH --mem=100GB
#SBATCH --time=00:10:00
#SBATCH --exclusive      

# --- Load the required modules
module load openMPI/5.0.5

# --- vars
export codedir=$(pwd)/bin/libexec/osu-micro-benchmarks/mpi/pt2pt

# ------- Run the benchmarks

echo " -------- Latency benchmark -------- "
mpirun -np 2 $codedir/osu_latency

echo " -------- Bandwidth benchmark -------- "
mpirun -np 2 $codedir/osu_bw
```

</details>

<details>
<summary>On 2 nodes</summary>

```bash
#!/bin/bash
#SBATCH --no-requeue
#SBATCH --job-name="osu"
#SBATCH --get-user-env
#SBATCH --account=lade
#SBATCH --partition=GENOA
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=12
#SBATCH --mem=100GB
#SBATCH --time=00:10:00
#SBATCH --exclusive      

# --- Load the required modules
module load openMPI/5.0.5

# --- vars
export codedir=$(pwd)/bin/libexec/osu-micro-benchmarks/mpi/pt2pt

# ------- Run the benchmarks

echo " -------- Latency benchmark -------- "
mpirun -np 2 $codedir/osu_latency

echo " -------- Bandwidth benchmark -------- "
mpirun -np 2 $codedir/osu_bw
```

</details>
</details>


## Commenting the results

Running the benchmarks on the same node, we can expect to have a very low latency (in the order of microseconds) and a very high bandwidth (in the order of Gigabytes per second), because the communication is happening through the shared memory of the node, which is very fast.

We can see that the in-RAM communication can reach a 0.10 $\mu s$ and a bandwidth of 31,76 GB/s:

<div style="display: flex; gap: 2rem;">

<div style="flex: 1;">
```
# OSU MPI Latency Test v7.5.2
# Datatype: MPI_CHAR.
# Size       Avg Latency(us)
1                       0.10
2                       0.10
4                       0.10
8                       0.10
16                      0.10
32                      0.10
64                      0.11
128                     0.18
256                     0.18
512                     0.19
1024                    0.22
2048                    0.30
4096                    0.38
8192                    0.48
16384                   0.82
32768                   1.36
65536                   2.40
131072                  4.24
262144                 10.22
524288                 17.97
1048576                34.70
2097152                68.00
4194304               133.31
```
</div> <div style="flex: 1;">
```
# OSU MPI Bandwidth Test v7.5.2
# Datatype: MPI_CHAR.
# Size      Bandwidth (MB/s)
1                      23.27
2                      46.12
4                      95.50
8                     189.23
16                    384.34
32                    657.69
64                   1349.25
128                  1971.63
256                  2690.86
512                  5362.82
1024                 9472.29
2048                11600.51
4096                17384.04
8192                34960.34
16384               22044.89
32768               16360.70
65536               22617.90
131072              27893.56
262144              31575.44
524288              33823.91
1048576             31934.06
2097152             31624.42
4194304             31755.16
```
</div> </div>


The most intresting part is when we run the benchmarks on two different nodes, where the communication is happening through the network, which in our case is an 200Gbit/s Infiniband network. In this case we can expect to have a higher latency (in the order of tens of microseconds) and a lower bandwidth (in the order of hundreds of Gigabytes per second), because the communication is happening through the network, which is slower than the shared memory of the node.

The obtained result shows a latency of 1.34 $\mu s$ and a bandwidth of 24.76 GB/s (which is roughly 198 Gbit/s):

<div style="display: flex; gap: 2rem;">

<div style="flex: 1;">
```
# OSU MPI Latency Test v7.5.2
# Datatype: MPI_CHAR.
# Size       Avg Latency(us)
1                       1.34
2                       1.34
4                       1.34
8                       1.34
16                      1.36
32                      1.45
64                      1.49
128                     1.51
256                     1.80
512                     1.85
1024                    2.15
2048                    2.27
4096                    2.56
8192                    3.07
16384                   4.01
32768                   5.20
65536                   8.04
131072                 13.58
262144                 15.41
524288                 26.05
1048576                47.22
2097152                89.88
4194304               174.24
```
</div> <div style="flex: 1;">
```
# OSU MPI Bandwidth Test v7.5.2
# Datatype: MPI_CHAR.
# Size      Bandwidth (MB/s)
1                       4.85
2                       9.74
4                      19.44
8                      39.65
16                     79.27
32                    156.19
64                    307.94
128                   610.30
256                  1128.19
512                  2073.82
1024                 3663.77
2048                 5581.60
4096                 8112.97
8192                11627.75
16384               20538.53
32768               22824.77
65536               23558.55
131072              24213.54
262144              24504.48
524288              24643.49
1048576             24706.84
2097152             24745.92
4194304             24761.78
```
</div> </div>


!!! abstract "Exercise"
    Try to run the benchmarks on EPYC and compare the results with the ones obtained on Genoa? Do you see any difference? Why?

    Try to explore the other communication patterns, like the collective communication patterns, and see how they perform on the system.


---
<br>
Authors: Isac Pasianotto, Stefano Cozzini

