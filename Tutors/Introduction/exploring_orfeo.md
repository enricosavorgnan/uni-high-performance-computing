---
icon: material/compass
---

# Exploring ORFEO

## Using ssh to log into ORFEO

After receiving an account to log into ORFEO (we will use the user name `jsalvalaggio` for this example, but do change it with yours when running the following commands!), you can login into the machine with
```console
$ ssh jsalvalaggio@195.14.102.215 
```
Note that all instructions here will assume you are running them from a UNIX machine and they might not be correct if you are using Windows.
For convenience, you can also edit you ssh config file to name this connection. Open `.ssh/config` (create it if it does not exist) and add the following lines:
```sshconfig
Host orfeo
    HostName 195.14.102.215
    User jsalvalaggio
```
You should then be able to connect to the server by just running
```console
$ ssh orfeo
```

## Your home directory in ORFEO

After logging in, you will find yourself in the login node, greeted by the following screen:
```console
        __     _____    ______    __
       /  \   |  __ \  |______|  /  \
      / /\ \  | |  ) )  ____    / /\ \
     / __)\ \ | | / /  |____|  / __)\ \
    / /    \ \| | \ \_________/ /    \ \
   /_/      \___|  `.__________/      \_\
   __  __   __     __ __    __  __  __
  (__ /   |/_ |\ |/  /_    [__)[__][__)|_/
   __)\__ |\__| \|\__\__   |   |  ||  \| \

   Welcome to ORFEO - v1.2.0

   Documentation Link = https://orfeo-doc.areasciencepark.it
   Changelog Link     = https://orfeo-doc.areasciencepark.it/changelog

=====
We remind you that quotas are enforced in the home directory.
If the size of your home directory is above 200GB,
you won't be able to write any more data, and you need to move
some of it to your scratch folder or NFS folder.

You can check how much space you are using and how much is left 
in your home directory with the command: "myquota"
=====

== Where are my data?

- data on NFS storage is now in =/orfeo/LTS/{{ group name }}/LT_Storage/=
- scratch data is now in =/orfeo/scratch/{{ groups[0] }}/{{ whoami }}/=


========= ATTENTION =========

Make sure to use -A <ACCOUNT NAME>  during job submission.
Omitting the account will cause some trouble
To discover your ACCOUNT NAME use this command:

sacctmgr list associations Users=$(whoami) format=Account,User,Partition

========= ATTENTION =========

Last login: Thu Jan 29 15:08:13 2026 from 195.14.102.43
jsalvalaggio@login01:~$
```
Take a look at the last line. It is telling you that I am user `jsalvalaggio` (it will show your username in your case) and I am logged in the host called `login01`.
Always keep and eye on the host name, as it will indicate whether you are on the login node or the compute nodes (where you actually want to run code, as we will see later).

## Environment variables

We can check the path to our home directory with `pwd`
```console
jsalvalaggio@login01:~$ pwd
/u/area/jsalvalaggio
```
All environment variables, that is all variables that store the information on the properties of the shell environment you are running on, are available with the `env` command.
Try it, and you will see it prints a lot of information.
Among these are some paths that indicate which directory the shell can go and look for e.g. executables to call, so that you don't have to type the whole path for each command you run.
For instance, these paths allow you to run the previous command as `env` and not `/usr/bin/env`.
You can print them with `env | grep PATH`:
```console
FPATH=/usr/share/lmod/lmod/init/ksh_funcs
__LMOD_REF_COUNT_MODULEPATH=/orfeo/opt/modules/tools:1;/orfeo/opt/modules/mpi:1;/orfeo/opt/modules/libraries:1;/etc/modulefiles:1;/usr/share/modulefiles/Linux:1;/usr/share/modulefiles/Core:1
MANPATH=/usr/share/lmod/lmod/share/man:
MODULEPATH_ROOT=/usr/share/modulefiles
DEBUGINFOD_IMA_CERT_PATH=/etc/keys/ima:
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
MODULEPATH=/orfeo/opt/modules/tools:/orfeo/opt/modules/mpi:/orfeo/opt/modules/libraries:/etc/modulefiles:/usr/share/modulefiles/Linux:/usr/share/modulefiles/Core
```


## HPC Partitions

As mentioned earlier, the login node is only your interface with the part of the cluster that actually runs your code.
Those are the compute nodes.
Nodes with similar properties are grouped together and organized in partitions.
While you can request specific nodes for you jobs, it is more common to use partitions to allocate resources.
We can inspect what partitions are present in the cluster using SLURM (see the [SLURM tutorial](using_slurm.md) for more information):
```console
jsalvalaggio@login01:~$ scontrol show partition | grep PartitionName | awk -F= '{ print $2 }'
EPYC
THIN
GPU
DGX
H100
GENOA
UPDATE
```
There are various different partitions that can suit different type of needs.
Here is a detailed list of their properties[^1]:

|   Name    |   # of nodes  |   CPU architecture    |   cores per node   |   CPU memory per node |   GPU architecture    | GPU memory   |
| --------- | ------------- | --------------------- | ------------------ | --------------------- | --------------------- | --------------------- |
|   EPYC    |   8           |   2x AMD EPYC 7H12               |   128      |   512GB           | - | - |
|   THIN    |   2 + 10      |   2x Intel Xeon Gold 6154 / 6126 | 36 / 24    |   1536GB / 768GB  | - | - |
|   GPU     |   4           |   2x Intel Xeon Gold 6226        |   24       |   256GB           | 2x V100 PCIe  |   32GB |
|   DGX     |   2           |   2x AMD EPYC 7H12               |   128      |   1TB             | 8x A100 SXM   |   40GB |   
|   H100    |   3           |   2x Intel Xeon Platinum 8480    | 112        |   1TB             | 8x H100 SXM   |   80GB |
|   GENOA   |   13          |   2x AMD EPYC 9374F              | 64         |   512GB           | - | - |
|   UPDATE  | -             |   *used for maintenance*         | -          | -                 | - | - | 

<!--
Let us take a closer look to, for example, the GENOA partition, counting 12 nodes each with 64 CPUs and 500GB of memory:
```console
jsalvalaggio@login01:~$ scontrol show partition GENOA
PartitionName=GENOA
   AllowGroups=ALL AllowAccounts=ALL AllowQos=ALL
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=00:10:00 DisableRootJobs=YES ExclusiveUser=NO ExclusiveTopo=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=6-06:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED MaxCPUsPerSocket=UNLIMITED
   Nodes=genoa[001-003,005-013]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=OFF
   State=UP TotalCPUs=768 TotalNodes=12 SelectTypeParameters=NONE
   JobDefaults=(null)
   DefMemPerCPU=1024 MaxMemPerNode=UNLIMITED
   TRES=cpu=768,mem=6000G,node=12,billing=768
```
--->

<!--
!!! tip

    Check the [bash cheat sheet](bash_cheat_sheet.md) for more info on `grep`, `awk`, and many other commands.
--->


## Storage

Checking the directories in your home you will see two of them are a symbolic link to directories in `/orfeo/cephfs/scratch` and `/orfeo/cephfs/fast`
```console
jsalvalaggio@login01:~$ ls -l
total 1
lrwxrwxrwx 1 root         root         36 Dec  9 14:11 fast -> /orfeo/cephfs/fast/area/jsalvalaggio
drwxr-xr-x 3 jsalvalaggio jsalvalaggio  1 Dec 11 11:45 ondemand
lrwxrwxrwx 1 root         root         39 Dec  9 14:11 scratch -> /orfeo/cephfs/scratch/area/jsalvalaggio
```
These are intended as a *temporary* working area for ORFEO users, without storage quotas, unlike the space on your home directory, that cannot hold more than 200GB.
Note that, however, files older than 30 days might be deleted from `scratch` and `fast` in the event space runs out on the cluster[^2].

!!! tip "Checking your available storage"

    You can run command `myquota` to check how much of your 200GB home folder quota is still available:
    ```console
    jsalvalaggio@login01:~$ myquota
    The disk space used by your home is: 0.153 GB and you have 397 files 
    Disk usage percentage occupancy: 0.077 %
    File percentage occupancy 0.040 % 
    Warning: when file usage reaches 90% you may still experience quota issues!
    ```

You can check where the filesystem is mounted and how much space is left on the cluster with the `df` command
```console
jsalvalaggio@login01:~$ df -h fast/
Filesystem                  Size  Used Avail Use% Mounted on
10.128.6.211:[...]:6789:/   4.9P  1.4P  3.5P  29% /orfeo/cephfs
```
Almost 5 petabytes of total storage!


[^1]: Note that node availability may vary due to maintenance operations. What is reported here is the maximum node counts, i.e. the actual hardware.
[^2]: The age of a file is calculated based on the time of last modification, so files that have been created a long time ago that are *actively* being changed will not be deleted.
Note that any attempt to circumvent the 30-day rule by means of "faking" modifications (such as scripts periodically updating files that would otherwise be untouched) could result in a termination of your account.

<br>
Authors: Jacopo Salvalaggio, Stefano Cozzini
