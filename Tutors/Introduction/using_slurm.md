---
icon: material/server-network
---

# Allocating resources with SLURM

## What is SLURM?

SLURM is a scheduler, that is a program that allocates and schedules resources for running jobs.
It is a fundamental part of the cluster workflow, allowing users to access the compute nodes (*note*: no job should be run on the login node, as the names suggest!)
The cluster counts various partitions: EPYC, THIN, GPU, DGX, H100, GENOA, UPDATE.
We will now dive deep and describe all fundamental commands of SLURM.


## Basic commands

### `sinfo`

`sinfo` prints information about nodes and partitions.
```console
jsalvalaggio@login01:~$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
EPYC         up 6-06:00:00      4    mix epyc[001-003,008]
EPYC         up 6-06:00:00      3   idle epyc[004-006]
THIN         up 6-06:00:00      3  alloc thin[002-003,007]
THIN         up 6-06:00:00      2   idle fat[001-002]
GPU          up   18:00:00      1    mix gpu001
GPU          up   18:00:00      2   idle gpu[002-003]
DGX          up 6-06:00:00      1    mix dgx001
DGX          up 6-06:00:00      1   idle dgx002
H100         up 6-06:00:00      1    mix dgx003
H100         up 6-06:00:00      1   idle dgx004
GENOA        up 6-06:00:00      6  alloc genoa[005-010]
GENOA        up 6-06:00:00      6   idle genoa[001-003,011-013]
UPDATE       up    1:00:00      1  drain genoa004
UPDATE       up    1:00:00      1   idle thin008
```
The command has given us useful information about the status of the cluster.
For instance, it is telling us that 3 nodes in the THIN partition are allocated (that is, they are being used by someone) and that 2 are idle.
If we can access the latter, we can launch a job that lasts at most 6 days and 6 hours; after that, it will be terminated.

Common options for this command are `-l, --long` to print more detailed information and `-N, --Node` to print information in a node-oriented format, that is node by node instead of grouping them per partition.
If you check the manual (`man sinfo`), you will see there are a great deal of options to sort and filter the nodes being listed.
For example, `-t, --states` filters the list by state, so if you wish to print all idle nodes you can run `sinfo -N -t IDLE` or equivalently `sinfo -N | grep idle`[^1]:
```console
jsalvalaggio@login01:~$ sinfo -l -N -t IDLE
Tue Feb 03 12:25:49 2026
NODELIST   NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
dgx002         1       DGX        idle 256    2:64:2 100000        0    100   (null) none                
epyc004        1      EPYC        idle 128    2:64:1 512000        0    100   (null) none                
epyc005        1      EPYC        idle 128    2:64:1 512000        0    100   (null) none                
epyc006        1      EPYC        idle 128    2:64:1 512000        0    100   (null) none                
fat002         1      THIN        idle 36     2:18:1 153600        0    110   (null) none                
genoa001       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
genoa002       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
genoa003       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
genoa011       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
genoa012       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
genoa013       1     GENOA        idle 64     2:32:1 512000        0    100   (null) none                
gpu003         1       GPU        idle 48     2:12:2 240000        0    100   (null) none                
thin008        1    UPDATE        idle 24     2:12:1 768000        0    100   (null) none
```
Notice we used the `-l` option to print more information about the nodes (`S:C:T` stands for "**S**ocket:**C**ore:**T**hreads").

The `-l` option is simply a shortcut for changing the format of the output of `sinfo`.
You can fine-tune this format with the `-o, --format` option.
For example, `-l` is equivalent to `--format "%#P %.5a %.10l %.10s %.4r %.8h %.10g %.6D %.11T %.11i %N"`.
A useful output format, with very detailed information about the status of the cluster is the following:
```console
jsalvalaggio@login01:~$ sinfo -N --format="%.15N %.6D %.10P %.11T %.4c %.10z %.8m %.10e %.9O %.15C"
       NODELIST  NODES  PARTITION       STATE CPUS      S:C:T   MEMORY   FREE_MEM  CPU_LOAD   CPUS(A/I/O/T)
         dgx001      1        DGX       mixed  256     2:64:2  1000000     983221      3.47    36/220/0/256
         dgx002      1        DGX        idle  256     2:64:2  1000000    1001525      2.22     0/256/0/256
         dgx003      1       H100       mixed  112     2:56:1  1000000     867599      5.34     35/77/0/112
         dgx004      1       H100       mixed  112     2:56:1  1000000     990310     34.99     50/62/0/112
        epyc001      1       EPYC       mixed  128     2:64:1   512000     146732     33.82    113/15/0/128
        epyc002      1       EPYC       mixed  128     2:64:1   512000     279735      2.69     78/50/0/128
        epyc003      1       EPYC        idle  128     2:64:1   512000     253881      0.69     0/128/0/128
[...]
```
`CPUS(A/I/O/T)` indicates "**A**vailable/**I**dle/**O**ther/**T**otal" cores.


### `squeue`

`squeue` lists jobs in the queue.
Formatting options are handed similarly to `sinfo`.
By default, it will show you jobs submitted by all users:
```console
jsalvalaggio@login01:~$ squeue -l
Tue Feb 03 14:10:17 2026
             JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
            889233       DGX vscode-t  malessi  RUNNING    3:01:17  12:00:00      1 dgx001
            889969       DGX     bash lpalacio  RUNNING      17:17   5:15:00      1 dgx001
        886405_484      EPYC 01_sim_t scocomel  PENDING       0:00  12:00:00      1 (launch failed requeued held)
        886405_104      EPYC 01_sim_t scocomel  PENDING       0:00  12:00:00      1 (launch failed requeued held)
          886405_4      EPYC 01_sim_t scocomel  PENDING       0:00  12:00:00      1 (launch failed requeued held)
            877780      EPYC Orid0086 licastro  RUNNING 4-01:25:27 5-08:00:00      1 epyc001
          883977_1      EPYC cll_abc_ rbergami  RUNNING    6:14:27 4-00:00:00      1 epyc008
          882582_5      EPYC cll_abc_ rbergami  RUNNING 1-07:04:58 4-00:00:00      1 epyc002
            889685      EPYC oa-bopt- lgrisant  RUNNING      48:18 4-12:00:00      1 epyc008
            889687      EPYC oa-bopt- lgrisant  RUNNING      48:18 4-12:00:00      1 epyc008
            889683      EPYC oa-bopt- lgrisant  RUNNING      48:21 4-12:00:00      1 epyc008
            879842      EPYC    oa-jl lgrisant  RUNNING   13:11:16 3-18:00:00      1 epyc001
            889813      EPYC   codium   dtesta  RUNNING      28:08  12:00:00      1 epyc008
          882582_1      EPYC cll_abc_ rbergami  RUNNING 1-22:34:59 4-00:00:00      1 epyc001
          882582_3      EPYC cll_abc_ rbergami  RUNNING 1-22:34:59 4-00:00:00      1 epyc002
            889386      EPYC   nexafs mbiagett  RUNNING    2:30:53 2-00:00:00      1 epyc008
            889970      EPYC haddock3   ssenci  RUNNING      16:42   6:00:00      1 epyc002
         882690_70     GENOA mountain mbiagett  PENDING       0:00  12:00:00      1 (launch failed requeued held)
        881446_138     GENOA mountain mbiagett  PENDING       0:00  12:00:00      1 (launch failed requeued held)
        872642_171     GENOA mountain mbiagett  PENDING       0:00 1-00:00:00      1 (launch failed requeued held)
            889393      H100 lora-tra    egoat  PENDING       0:00     10:00      1 (BeginTime)
            889812      H100     bash mprone00  RUNNING      28:36   5:00:00      1 dgx003
            889977      H100 training cuturell  RUNNING       1:39 2-02:00:00      1 dgx004
            889779      H100     bash  lbasile  RUNNING      39:32  12:00:00      1 dgx003
            887875      H100     bash    egoat  RUNNING    4:20:41   8:00:00      1 dgx003
            889228      H100     test ygardina  RUNNING    3:20:50   8:00:00      1 dgx003
            889227      H100   @@bash francesc  RUNNING    3:31:07   8:00:00      1 dgx003
            889448      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889449      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889450      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889451      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889452      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889453      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
            889454      THIN  Mutect2     fvit  PENDING       0:00  12:00:00      1 (Priority)
[...]
```
You can specify the user (or a list of users) you want to see the jobs of with the `-u, --user` option
```console
jsalvalaggio@login01:~$ squeue -l -u jsalvalaggio
Tue Feb 03 14:21:39 2026
             JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
            889978      THIN     bash jsalvala  RUNNING       9:31     10:00      1 fat001
```
However, if you wish to keep track of the status of your submitted jobs, the `sacct` command is more suited for the task (pun intended...)


### `sacct`

`sacct` describes the status of all the jobs you (or some user) launched.
By default, it will print everything you sent in the current day:
```console
jsalvalaggio@login01:~$ sacct
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
889978             bash       THIN       lade          1    TIMEOUT      0:0 
889978.exte+     extern                  lade          1  COMPLETED      0:0 
889978.0           bash                  lade          1  CANCELLED      0:9
```
We can see I have run one job today that ended because it run out of time.
However, the default view does not provide information on how long the job took; we can change it again via the `-o, --format` option (run `sacct -e` to see all possible fields that can be used for formatting, they are a lot!)
```console
jsalvalaggio@login01:~$ sacct -o "JobID, JobName, Partition, Account, AllocCPUS, Start, Elapsed, State"
JobID           JobName  Partition    Account  AllocCPUS               Start    Elapsed      State 
------------ ---------- ---------- ---------- ---------- ------------------- ---------- ---------- 
889978             bash       THIN       lade          1 2026-02-03T14:12:08   00:10:21    TIMEOUT 
889978.exte+     extern                  lade          1 2026-02-03T14:12:08   00:10:53  COMPLETED 
889978.0           bash                  lade          1 2026-02-03T14:12:11   00:10:50  CANCELLED 
```
It is also useful to filter by start time with the `-S, --starttime` option[^2]:
```console
jsalvalaggio@login01:~$ sacct -S 14:00 -u mbiagetti -o "JobID, JobName, Partition, Account, AllocCPUS, Start, Elapsed, State"
JobID           JobName  Partition    Account  AllocCPUS               Start    Elapsed      State 
------------ ---------- ---------- ---------- ---------- ------------------- ---------- ---------- 
872642_171   mountaine+      GENOA       lade          0             Unknown   00:00:00    PENDING 
881446_138   mountaine+      GENOA       lade          0             Unknown   00:00:00    PENDING 
882690_70    mountaine+      GENOA       lade          0             Unknown   00:00:00    PENDING 
889386           nexafs       EPYC       lade          1 2026-02-03T11:39:24   03:00:54    RUNNING 
889386.batch      batch                  lade          1 2026-02-03T11:39:24   03:00:54    RUNNING 
889386.exte+     extern                  lade          1 2026-02-03T11:39:24   03:00:54    RUNNING 
889995_0     N16_mlp_r+        DGX       lade          4 2026-02-03T14:29:00   00:03:40  COMPLETED 
889995_0.ba+      batch                  lade          4 2026-02-03T14:29:00   00:03:40  COMPLETED 
889995_0.ex+     extern                  lade          4 2026-02-03T14:29:00   00:03:41  COMPLETED 
889995_1     N16_mlp_r+        DGX       lade          4 2026-02-03T14:29:00   00:03:40  COMPLETED 
889995_1.ba+      batch                  lade          4 2026-02-03T14:29:00   00:03:40  COMPLETED 
889995_1.ex+     extern                  lade          4 2026-02-03T14:29:00   00:03:40  COMPLETED 
889995_2     N16_mlp_r+        DGX       lade          4 2026-02-03T14:29:00   00:03:37  COMPLETED 
889995_2.ba+      batch                  lade          4 2026-02-03T14:29:00   00:03:37  COMPLETED 
889995_2.ex+     extern                  lade          4 2026-02-03T14:29:00   00:03:37  COMPLETED 
889995_3     N16_mlp_r+        DGX       lade          4 2026-02-03T14:29:00   00:03:39  COMPLETED 
889995_3.ba+      batch                  lade          4 2026-02-03T14:29:00   00:03:39  COMPLETED 
889995_3.ex+     extern                  lade          4 2026-02-03T14:29:00   00:03:39  COMPLETED 
889995_4     N16_mlp_r+        DGX       lade          4 2026-02-03T14:29:00   00:03:41  COMPLETED 
889995_4.ba+      batch                  lade          4 2026-02-03T14:29:00   00:03:41  COMPLETED 
889995_4.ex+     extern                  lade          4 2026-02-03T14:29:00   00:03:41  COMPLETED
```

### `srun`


`srun` is the basic SLURM utility used to send a command to the compute nodes.
It works as `srun [options] [command]`.
Let us use a very simple example to illustrate how `srun` and its options work[^3].
The command `hostname` returns the name of the host your shell is running on.
From the login node, we get
```console
jsalvalaggio@login01:~$ hostname
login01.hpc.rd.areasciencepark.it
```
Now we want to run this code on a compute node instead of the login one.
In order to do that, we use `srun`:
```console
jsalvalaggio@login01:~$ srun --partition GENOA --account lade --nodes 1 --ntasks 1 hostname
genoa001.hpc.rd.areasciencepark.it
```
Before going over the meaning of all the options we added, let us just drive the main point: with `srun` we have run the command `hostname` on a node different than the login, as the output suggests.
The options included in the example are:

+ `-p, --partition=<names>`, the name(s) of the partition(s) we want to run our code on;
+ `-A, --account=<name>`, the name of your SLURM account (see warning below);
+ `-N, --nodes=<number>`, number of nodes to allocate for the job;
+ `-n, --ntasks=<number>`, number of tasks needed for the job.

!!! warning
    
    Always write your account name when submitting jobs. It is most likely `lade`, `dssc` or `cdslab`.

!!! warning

    Always be careful not to allocate more resources than needed for your job.

Other useful options are:

+ `--ntasks-per-node=<number>`, number of tasks per node (beware of override from `-n`);
+ `-c, --cpus-per-task=<number>`, number of processors per task (fundamental when working with OpenMP, [as we will see](../ParallelProgramming/omp_basics.md));
+ `--mem=<size>`, memory requirement per node;
+ `-t, --time=<time>`, time limit for the job;
+ `-b, --begin=<date/time>`, begin time for the job;
+ `-J, --job-name=<name>`, name of the job;
+ `--exclusive`, specify that job cannot share a node with other jobs, even if it does not use all of its cores;
+ `-D, --chdir=<name>`, directory to `cd` into before starting execution;
+ `--pty`, execute task in an interactive shell.

Please refer to the manual for an exhaustive list of options and for the format to be used for time limits and begin times.

The last option is used to open an interactive shell session on a node:
```console
jsalvalaggio@login01:~$ srun --partition GENOA --account lade --nodes 1 --ntasks 1 --time 01:00:00 --pty bash
jsalvalaggio@genoa001:~$ 
```
Notice the change of host in the bash prompt.
With this command we have basically told SLURM to allocate resourced to run (in an interactive way) the command `bash`.

!!! warning

    We reccommend always using `salloc` for launching MPI jobs.
<!-- Using a `--pty bash` interactive session to launch MPI jobs across nodes will not work, use `salloc` instead. (Is this true? Need to check JS) -->


### `sbatch`

`sbatch` can be used to submit a script that requests resources and executes a job.
The script should contain directives on how to allocate resources, that is `sbatch` options.
A very simple example script is:
```sh title="sbatch_script.sh"
#!/bin/bash
#SBATCH --partition=GENOA
#SBATCH --account=lade
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --time=01:00:00
#SBATCH --output=slurm_output_%j.out
#SBATCH --error=slurm_error_%j.err

echo "Working directory:" $(pwd)
echo "Name of the host:" $(hostname)
echo "Date and time:" $(date)
echo "Message:" "Hello, world!"
```
Naturally, `--pty` is no longer an option here, since `sbatch` always runs the commands of the script and then exits, thus making it impossible for it to open an interactive shell.
We do have some options to specify where to write the output and the error messages coming from the script that are not available with `srun` since it writes directly to standard output and error.
Note that `%j` in the output and error file specification stands for the job ID and thus provides a unique identifier per job.

We can run the script like this:
```console
jsalvalaggio@login01:~$ sbatch sbatch_script.sh
Submitted batch job 890304
jsalvalaggio@login01:~$ cat slurm_output_890304.out 
Working directory: /u/area/jsalvalaggio
Name of the host: genoa001.hpc.rd.areasciencepark.it
Date and time: Tue 3 Feb 16:20:00 CET 2026
Message: Hello, world!
```
All options declared at the beginning of the script can also be specified as command-line options of the   `sbatch` command.
In that case, they will override what is written in the script:
```console
jsalvalaggio@login01:~$ sbatch -p THIN sbatch_script.sh
Submitted batch job 890307
jsalvalaggio@login01:~$ cat slurm_output_890307.out 
Working directory: /u/area/jsalvalaggio
Name of the host: fat001.hpc.rd.areasciencepark.it
Date and time: Tue 3 Feb 16:27:01 CET 2026
Message: Hello, world!
```
Notice the different host name after we specified a different partition from the command line.


### `salloc`

`salloc` works in a slightly different way with respect to `srun`.
While like the latter it is used to allocate some resources for a command on a node, it will *not* directly run that command on the node.
To illustrate this, we can use the same example we have used before and check the return value of the `hostname` command:
```console
jsalvalaggio@login01:~$ salloc --partition GENOA --account lade --nodes 1 --ntasks 1 hostname
salloc: Granted job allocation 891936
salloc: Waiting for resource configuration
salloc: Nodes genoa001 are ready for job
login01.hpc.rd.areasciencepark.it
salloc: Relinquishing job allocation 891936
```
You can see that even though the job was accepted and resources on node 001 of the GENOA partition were allocated, the shell from which the command is run is still the one of the login node (since the host is `login01`).
So, `salloc` is only used to set some resources aside for you; then, you have to use these resources via `srun`.
The syntax is `salloc [options] [command]`, where the command should be of the type `srun <something>` *if* you want it to run on the compute node[^4].
So, let us retry the previous example, this time including `srun` in the command:
```console
jsalvalaggio@login01:~$ salloc --partition GENOA --account lade --nodes 1 --ntasks 1 srun hostname
salloc: Granted job allocation 891965
salloc: Waiting for resource configuration
salloc: Nodes genoa001 are ready for job
genoa001.hpc.rd.areasciencepark.it
salloc: Relinquishing job allocation 891965
```

!!! note
    
    When invoking `srun` through `salloc`, it is not necessary to pass any options, as the resources have already been allocated.

It is also possible to use `salloc` in interactive mode by omitting the command.
This way, you will remain on the login node shell but you will be able to launch jobs on the nodes via `srun` on your allocated resources.
```console
jsalvalaggio@login01:~$ salloc --partition GENOA --account lade --nodes 1 --ntasks 1 --time 01:00:00
salloc: Granted job allocation 891990
salloc: Waiting for resource configuration
salloc: Nodes genoa001 are ready for job
jsalvalaggio@login01:~$ hostname
login01.hpc.rd.areasciencepark.it
jsalvalaggio@login01:~$ srun hostname
genoa001.hpc.rd.areasciencepark.it
jsalvalaggio@login01:~$ srun -p THIN hostname
genoa001.hpc.rd.areasciencepark.it
jsalvalaggio@login01:~$ exit
exit
salloc: Relinquishing job allocation 891990
```
As you can see, the `-p THIN` option passed to `srun` was ignored as `salloc` had allocated resources on the GENOA partition.
When you no longer need your resources, run `exit` or ++ctrl+d++ to relinquish them.


### `scancel`

Used to cancel pending or running jobs.
The syntax is `scancel [options] <id>`.
```console
jsalvalaggio@login01:~$ sbatch -A lade -p GENOA -n 1 -N 1 some_script.sh
Submitted batch job 892085
jsalvalaggio@login01:~$ sacct -j 892085
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
892085       some_scri+      GENOA       lade          1    RUNNING      0:0 
892085.batch      batch                  lade          1    RUNNING      0:0 
892085.exte+     extern                  lade          1    RUNNING      0:0 
jsalvalaggio@login01:~$ scancel 892085
jsalvalaggio@login01:~$ sacct -j 892085
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
892085       some_scri+      GENOA       lade          1 CANCELLED+      0:0 
892085.batch      batch                  lade          1  CANCELLED      0:0 
892085.exte+     extern                  lade          1  CANCELLED      0:0 
```
Some useful options are:

+ `-i, --interactive` activates interactive mode, where you are asked to confirm before canceling each job;
+ `--me` selects your jobs;
+ `-t, --state=<state>` to select the state of the job to cancel, either "PENDING", "SUSPENDED" or "RUNNING".

```console
jsalvalaggio@login01:~$ for i in 1 2 3 4; do sbatch -A lade -p GENOA -n 1 -N 1 -J some_script_${i} some_script.sh; done
Submitted batch job 892114
Submitted batch job 892115
Submitted batch job 892116
Submitted batch job 892117
jsalvalaggio@login01:~$ scancel -i --me --state="RUNNING"
Cancel job_id=892114 name=some_script_1 partition=GENOA [y/n]? y
Cancel job_id=892115 name=some_script_2 partition=GENOA [y/n]? y
Cancel job_id=892116 name=some_script_3 partition=GENOA [y/n]? y
Cancel job_id=892117 name=some_script_4 partition=GENOA [y/n]? y
```


### `scontrol`

Used to know everything about a specific job: syntax is `scontrol show jobid <id>`
```console
jsalvalaggio@login01:~$ scontrol show job 891802
JobId=891802 JobName=bash
   UserId=mprone00(10080160) GroupId=mprone00(10080160) MCS_label=N/A
   Priority=80091 Nice=0 Account=lade QOS=normal
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=0 Reboot=0 ExitCode=0:0
   RunTime=01:25:37 TimeLimit=05:00:00 TimeMin=N/A
   SubmitTime=2026-02-04T10:17:17 EligibleTime=2026-02-04T10:17:17
   AccrueTime=Unknown
   StartTime=2026-02-04T10:17:17 EndTime=2026-02-04T15:17:17 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2026-02-04T10:17:17 Scheduler=Main
   Partition=H100 AllocNode:Sid=10.128.6.80:2557711
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=dgx003
   BatchHost=dgx003
   NumNodes=1 NumCPUs=8 NumTasks=1 CPUs/Task=8 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=8,mem=80G,node=1,billing=8,gres/gpu=1,gres/gpu:h100=1
   AllocTRES=cpu=8,mem=80G,node=1,billing=8,gres/gpu=1,gres/gpu:h100=1
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=8 MinMemoryNode=80G MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=bash
   WorkDir=/orfeo/cephfs/home/lade/mprone00
   TresPerNode=gres/gpu:H100:1
   TresPerTask=cpu=8
```


## Advanced SLURM usage

### Monitoring a job state and managing dependencies

Sometimes it can be useful to have a script that performs some actions depending on the final state of a SLURM job, be it `COMPLETED`, `FAILED`, `CANCELLED` or other.
In order to do so, you need both a script that can parse the outputs of SLURM utilities (e.g. `sacct`) and a way to schedule it to run *after* the original job is over.

Here is an example of a script to read the status of a job given its ID, and then execute some code depending on the value of said status:

```bash title="monitor_state.sh"
#!/bin/bash
#SBATCH --partition=GENOA
#SBATCH --account=lade
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=slurm_diagnostic_%j.out
#SBATCH --error=slurm_diagnostic_%j.err

# Script to run code according to the exit state of a given SLURM job
# Needs job id as input
# Check input ($# is the length of the input argument array)
if (($# != 1))
    then
    echo "Script expects a job id as input parameter"
    exit 1
fi
# Assign input argument to the job id variable
target_job_id=$1
##
# Call sacct to get information on job status
# Then, use awk to parse: on the third line of the output ("if (FNR == 3)") print the second word ("print $2")
##
target_job_status=$(sacct -j ${target_job_id} -o 'JobID, State%50' | awk '{ if (FNR == 3) { print $2 } }')
# Run case statement and execute code according to the status
case $target_job_status in
    COMPLETED)
        echo "Job was executed with no errors :)"
        ;;
    FAILED)
        echo "Job failed :("
        ;;
    CANCELLED)
        echo "Job was cancelled :|"
        ;;
    *)
        echo "[ERROR] Invalid job status"
        exit 1
        ;;
esac
```

Let us explain what the code does in a bit of detail:

1. First, we manually check that the number of arguments is correct. Here, we only want one input argument (i.e. the job ID).
See the [tutorial on bash scripting](bash_scripting.md) for more details and advanced examples using `getopt`. 

2. Then, we assign the status to the `target_job_status` variable. The way we do this is:
    * We invoke `sacct` and customize the columns it outputs to be the job ID and the state alone, since they are the only ones we need (in order to be sure the state string is not cut, I enforced the second column to be fifty characters wide with the `%50` specifier).
    * We call `awk`[^5] through a pipeline to parse the output: we select the second word of the third line as our target string. Do try to run `sacct -j <some job id> -o 'JobID, State%50'` to verify the layout yourself.

3. Finally, we use a `case` statement to decide what code to run based on the state of the job.
Remember to end each case with the double semicolon `;;`.
Also, note that `*)` represents the default case.

Of course, the code run being run here is, for the sake of this example, quite silly.
You can, however, customize the statements however you please.
For instance, you could be interested in clearing the contents of some directory in the case the job runs successfully, or anything else that comes to mind.

Now, let us review how to plan the above script to run after another job is finished.
You might have noticed that `monitor_state.sh` contains `sbatch` directives: indeed, we are going to schedule it with SLURM.
In order to do so, we use *dependencies*; here is some code that launches a SLURM job and contextually schedules `monitor_state.sh` to run after that job is done:

```bash title="sbatch_diagnostics.sh"
#!/bin/bash

# Script to launch a sbatch script and its corresponding diagnostic script, with correct dependencies
# Check input ($# is the length of the input argument array)
if (($# != 1))
    then
    echo "Script expects a sbatch script name as input parameter"
    exit 1
fi
# Assign input argument to script name variable
script_name=$1
# Launch sbatch script and save job id
job_id=$(sbatch --parsable ${script_name})
# Launch state monitoring script with the dependency to run after the original script has ended ("afterany")
aux_job_id=$(sbatch --parsable --dependency=afterany:${job_id} /u/area/jsalvalaggio/monitor_state.sh ${job_id})
echo Submitted batch job ${job_id} with auxiliary monitoring job ${aux_job_id}
```

Again, let us go through the script:

1. The first step is always to check input parameters. Here, we request the name of the script we want to launch.

2. We then launch said script and, in doing so, we retrieve the job ID and assign it to the `job_id` variable.
The `--parsable` flag helps us by suppressing the usual "Submitted batch job" from the output (but you could try to use `awk` without the flag as an exercise...)

3. We `sbatch` the `monitor_state.sh` script and ask it be run after the one we just launched above.
We do this with the `-d, --dependency=<dependecy list>` option: here, we ask it to run after job `#!bash ${job_id}` has finished with any state, hence `afterany`.
Another useful option is `singleton`, that will make sure that only one job with a given name is running at the same time (so, if you launch, say, 10 jobs at the same time with the same name, only one will run at a time).
Again, we save the job id of this auxiliary job.

4. We output the job id of the main and auxiliary script in order to keep track of them. 

??? question "Exercise"

    A very useful utility to edit files from command line that we have not talked about is `sed`.

    Let us give a brief example of how it works in a specific use case: substituting a word in a file.
    We start from a file `some_file.txt`:
    ```console
    jsalvalaggio@login01:~$ cat some_file.txt 
    Hello, world!
    ```
    If we want to substitute the word "world" with, say, "Universe", we can use sed with this syntax
    ```console
    jsalvalaggio@login01:~$ sed -i 's/world/Universe/g' some_file.txt 
    jsalvalaggio@login01:~$ cat some_file.txt 
    Hello, Universe!
    ```
    Here, `s` stands for "Substitute" and `g` enforces we substitute all occurences (only one in this case).
    The `-i, --in-place` flag makes sure we overwrite the original file, otherwise `sed` will run the command and print everything to standard output.
    Note that `sed` can do much more than just substituting strings in a file: you can check the full documentation on the [GNU website](https://www.gnu.org/software/sed/manual/sed.html).

    Let us then try and apply this command to our SLURM dependency scripts: as of now, the output (and error) of `monitor_state.sh` contains the job ID of the monitoring job, however it would be more intuitive for it to show the one of the associated, "true" job.
    Since the name of these files is defined within a `sbatch` directory that is, for all `bash` is concerned, just a comment, we will not get away with simply adding the input parameter value to the file names: that is, writing `#!bash #SBATCH  --output=slurm_diagnostic_${1}.out` will **not** work (try it yourself...)

    This is then a great opportunity to try out `sed`.
    We can modify `sbatch_diagnostics.sh` adding a line similar to this one:
    ```bash
    sed "s/\%j/${target_job_id}/g" monitor_state.sh > monitor_state_${target_job_id}.sh
    ```
    This substitutes the `%j` (we used the backslash to escape the percent character) in the directive with the actual job ID we want to see and then saves everything to a new copy of the script (so that we will not mess up when launching many jobs at a time).
    Note that here we have used double qoutes, not single, so that the variable value would be expanded; otherwise, `sed` would have actually done the replacement with the actual string `${target_job_id}` (see [here](https://www.gnu.org/software/bash/manual/bash.html#Quoting) for more details).
    Try to implement this yourself!
    Remember to change the name of the script being launched and to delete the new script copy at the end.

    






[^1]: The commands run for the examples seen in this tutorial have been run at different times, so they might not all show the same information on the state of the cluster.
[^2]: I am here using Matteo's account to show a longer and more varied history than my single job.
[^3]: As a quick foreshadowing, it is likely that you will use `sbatch` or `salloc` more, but since the three commands basically share the same options and `srun` (at least in my opinion - JS) is the most straightforward to use, it can be useful to understand the basic concepts of running code with SLURM with this one.
[^4]: This is not valid if you are calling `mpirun` in ORFEO, as it will automatically wrap `srun` and use the allocated resources to run the code. More on this in the [next tutorial](../ParallelProgramming/running_mpi.md).
[^5]: `awk` is a very useful programming language that you can use to parse any type of file or output. You can have a look at [this tutorial](https://www.geeksforgeeks.org/linux-unix/awk-command-unixlinux-examples/) to get started on the very basics.

<br>
Authors: Jacopo Salvalaggio, Niccolò Tosato, Stefano Cozzini
