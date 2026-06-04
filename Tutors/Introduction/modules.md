---
icon: material/view-module
---

# Handling and loading modules

## What is a module system? 

A module system is a software that helps us to manage our environment, the one described by the output of the `env` command. 

The environmental modules *add*, *modify* and *remove* environmental variables in a coherent way. 

## Basic commands

In this tutorial we explore the basic feature and the legacy usage of a module system with a particular focus on the MPI and ORFEO environment. 

### `module avail`

The command `module avail` or `ml avail` lists all available modules that can at the moment be loaded on the cluster.
From the **login node** with a fresh session we should get the following output:
```console
jsalvalaggio@login01:~$ module avail

------------------------------------------ /orfeo/opt/modules/tools -------------------------------------------
   IGV/2.18.0               fastp/0.23.4               java/21.0.2         (D)    plink/1.90
   R/4.4.1                  fastp/0.24.1        (D)    jupyterlab/4.4.7           sambamba/1.0
   R/4.5.0           (D)    fastqc/0.12.1              ont-guppy-cpu/6.2.1        sambamba/1.0.1     (D)
   STAR/2.7.11b             foldseek/8-ef4e960         ont-guppy-cpu/6.5.7 (D)    samtools/1.17
   bcftools/1.17            foldseek/10-941cd33 (D)    ont-guppy-gpu/6.2.1        samtools/1.21      (D)
   bcftools/1.21     (D)    gromacs/2025.1             ont-guppy-gpu/6.5.7 (D)    singularity/3.10.4
   bcl2fastq2/2.20.0        hwloc/2.12.0               openBLAS/0.3.26-omp        singularity/3.11.5
   bedtools2/2.31.1         java/1.8.0                 openBLAS/0.3.26            singularity/4.3.1  (D)
   bwa-mem2/2.2.1           java/8-8u402b06            openBLAS/0.3.29-omp        trim_galore/0.6.10
   cutadapt/4.2             java/11.0.22               openBLAS/0.3.29     (D)    vscode/4.106.2
   cutadapt/5.0      (D)    java/17.0.10               picard/3.4.0

------------------------------------------- /orfeo/opt/modules/mpi --------------------------------------------
   openMPI/4.1.6    openMPI/5.0.5 (D)

---------------------------------------- /orfeo/opt/modules/libraries -----------------------------------------
   cuda/11.8    cuda/12.1    cuda/12.8        (D)    openBLAS/0.3.26-omp    openBLAS/0.3.29-omp
   cuda/12.0    cuda/12.6    cutensor/2.2.0.0        openBLAS/0.3.26        openBLAS/0.3.29

  Where:
   D:  Default Module

If the avail list is too long consider trying:

"module --default avail" or "ml -d av" to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".
```
Modules are organized in categories (`tools`, `mpi`, `libraries`) and, if more versions of one module are available, one of them will be loaded by default (denoted by `(D)`).
That is, loading the `openMPI` module will load version 5.0.5, unless specified.

### `module load`

Let us now load the module necessary for using MPI.
First, without touching the configuration, try calling an MPI command such as `mpirun`.
You will notice an error is thrown, as the location of this command is not specified in the environment.
```console
jsalvalaggio@login01:~$ mpirun
-bash: mpirun: command not found
```
Indeed, the openMPI commands are stored in `/opt/programs/openMPI/`, that is not found in the `PATH` variable (to verify yourself, run `env | grep PATH` or `echo $PATH`).

So, let us load them with `module`
```console
jsalvalaggio@login01:~$ module load openMPI
jsalvalaggio@login01:~$ echo $PATH
/opt/programs/openMPI/5.0.5/bin:/opt/programs/hwloc/2.12.0/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
jsalvalaggio@login01:~$ mpirun --help
mpirun (Open MPI) 5.0.5

Usage: mpirun [OPTION]...

See the mpirun(1) man page or HTML help for a detailed list of command
line options that are available.

Report bugs to https://www.open-mpi.org/community/help/
```
A couple of observations are in order:

+ As mentioned before, without specifying which version of openMPI to load (for instance by calling `module load openMPI/4.1.6`), `module` has loaded the default, `5.0.5`;
+ Loading the module did nothing but apply some changes to the environment of our shell;
+ As you can see, the `PATH` variable has been changed so that it contains the path to the MPI commands such as `mpirun`;
+ `PATH` was not the only environmental variable that was changed: you will see many more new or modified variables by running `env | grep MPI`.

<details>
<summary>Exercise</summary>
As an exercise, try doing this: start a fresh shell in the cluster and compare the environment before and after loading the module
```console
jsalvalaggio@login01:~$ env > env_before
jsalvalaggio@login01:~$ module load openMPI
jsalvalaggio@login01:~$ env > env_after
jsalvalaggio@login01:~$ diff -u env_before env_after 
```

<details>
<summary>Output</summary>
```diff
--- env_after	2026-02-03 11:04:30.055445428 +0100
+++ env_before	2026-02-03 11:04:21.941762961 +0100
@@ -1,16 +1,12 @@
 SHELL=/bin/bash
 HISTCONTROL=ignoredups
-MPI_LIB=/opt/programs/openMPI/5.0.5/lib
-PKG_CONFIG_PATH=/opt/programs/hwloc/2.12.0/lib/pkgconfig
 HISTSIZE=1000
 HOSTNAME=login01.hpc.rd.areasciencepark.it
-HWLOC_HOME=/opt/programs/hwloc/2.12.0
 FPATH=/usr/share/lmod/lmod/init/ksh_funcs
 LC_ADDRESS=en_GB.UTF-8
-_ModuleTable002_=IHsKZm4gPSAiL29yZmVvL29wdC9tb2R1bGVzL21waS9vcGVuTVBJLzUuMC41Lmx1YSIsCmZ1bGxOYW1lID0gIm9wZW5NUEkvNS4wLjUiLApsb2FkT3JkZXIgPSAyLApwcm9wVCA9IHt9LApzdGFja0RlcHRoID0gMCwKc3RhdHVzID0gImFjdGl2ZSIsCnVzZXJOYW1lID0gIm9wZW5NUEkiLAp3ViA9ICIwMDAwMDAwMDUuMDAwMDAwMDAwLjAwMDAwMDAwNS4qemZpbmFsIiwKfSwKfSwKbXBhdGhBID0gewoiL29yZmVvL29wdC9tb2R1bGVzL3Rvb2xzIiwgIi9vcmZlby9vcHQvbW9kdWxlcy9tcGkiLCAiL29yZmVvL29wdC9tb2R1bGVzL2xpYnJhcmllcyIsICIvZXRjL21vZHVsZWZpbGVzIiwgIi91c3Ivc2hhcmUvbW9kdWxlZmlsZXMvTGludXgiLCAiL3Vzci9zaGFyZS9tb2R1bGVm
+_ModuleTable002_=dXNyL3NoYXJlL21vZHVsZWZpbGVzL0NvcmU6L3Vzci9zaGFyZS9sbW9kL2xtb2QvbW9kdWxlZmlsZXMvQ29yZSIsCn0K
 LC_NAME=en_GB.UTF-8
 __LMOD_REF_COUNT_MODULEPATH=/orfeo/opt/modules/tools:1;/orfeo/opt/modules/mpi:1;/orfeo/opt/modules/libraries:1;/etc/modulefiles:1;/usr/share/modulefiles/Linux:1;/usr/share/modulefiles/Core:1
-OMPI_MCA_btl=^ofi,usnic,openib
 LC_MONETARY=en_GB.UTF-8
 GPG_TTY=/dev/pts/48
 LMOD_DIR=/usr/share/lmod/lmod/libexec
@@ -19,23 +15,16 @@
 LOGNAME=jsalvalaggio
 XDG_SESSION_TYPE=tty
 MODULESHOME=/usr/share/lmod/lmod
-MANPATH=/opt/programs/openMPI/5.0.5/share/man:/opt/programs/hwloc/2.12.0/share/man:/usr/share/lmod/lmod/share/man::
-MPI_INCLUDE=/opt/programs/openMPI/5.0.5/include
-MPI_HOME=/opt/programs/openMPI/5.0.5
+MANPATH=/usr/share/lmod/lmod/share/man::
 MOTD_SHOWN=pam
-MPI_FORTARN_MOD_DIR=/opt/programs/openMPI/5.0.5/lib
-__LMOD_REF_COUNT_PATH=/opt/programs/openMPI/5.0.5/bin:1;/opt/programs/hwloc/2.12.0/bin:1;/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1
+__LMOD_REF_COUNT_PATH=/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1
 HOME=/u/area/jsalvalaggio
-_ModuleTable_Sz_=3
+_ModuleTable_Sz_=2
 LANG=en_US.UTF-8
 LC_PAPER=en_GB.UTF-8
 LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:
-__LMOD_REF_COUNT_PKG_CONFIG_PATH=/opt/programs/hwloc/2.12.0/lib/pkgconfig:1
 LMOD_SETTARG_FULL_SUPPORT=no
-LMOD_FAMILY_HWLOC=hwloc
-OMPI_MCA_mtl=^ofi
 LMOD_VERSION=8.7.55
-MPI_SYSCONFIG=/opt/programs/openMPI/5.0.5/etc
 SSH_CONNECTION=195.14.102.43 51241 10.128.4.15 22
 _ModuleTable003_=aWxlcy9Db3JlIiwKfSwKc3lzdGVtQmFzZU1QQVRIID0gIi9ldGMvbW9kdWxlZmlsZXM6L3Vzci9zaGFyZS9tb2R1bGVmaWxlczovdXNyL3NoYXJlL21vZHVsZWZpbGVzL0xpbnV4Oi91c3Ivc2hhcmUvbW9kdWxlZmlsZXMvQ29yZTovdXNyL3NoYXJlL2xtb2QvbG1vZC9tb2R1bGVmaWxlcy9Db3JlIiwKfQo=
 MODULEPATH_ROOT=/usr/share/modulefiles
@@ -43,39 +32,28 @@
 LMOD_PKG=/usr/share/lmod/lmod
 TERM=xterm-256color
 LC_IDENTIFICATION=en_GB.UTF-8
-PKG_LIBRARY_PATH=/opt/programs/openMPI/5.0.5/lib/pkgconfig
-__LMOD_REF_COUNT_PKG_LIBRARY_PATH=/opt/programs/openMPI/5.0.5/lib/pkgconfig:1
 LESSOPEN=||/usr/bin/lesspipe.sh %s
 USER=jsalvalaggio
-LOADEDMODULES=hwloc/2.12.0:openMPI/5.0.5
 LMOD_ROOT=/usr/share/lmod
 SHLVL=1
 BASH_ENV=/usr/share/lmod/lmod/init/bash
 LMOD_sys=Linux
 LC_TELEPHONE=en_GB.UTF-8
-MPI_BIN=/opt/programs/openMPI/5.0.5/bin
 LC_MEASUREMENT=en_GB.UTF-8
-__LMOD_REF_COUNT_MANPATH=/opt/programs/openMPI/5.0.5/share/man:1;/opt/programs/hwloc/2.12.0/share/man:1;/usr/share/lmod/lmod/share/man:1;:1
+__LMOD_REF_COUNT_MANPATH=/usr/share/lmod/lmod/share/man:1;:1
 XDG_SESSION_ID=79813
-_ModuleTable001_=X01vZHVsZVRhYmxlXyA9IHsKTVR2ZXJzaW9uID0gMywKY19yZWJ1aWxkVGltZSA9IGZhbHNlLApjX3Nob3J0VGltZSA9IGZhbHNlLApkZXB0aFQgPSB7fSwKZmFtaWx5ID0gewpod2xvYyA9ICJod2xvYyIsCm1waSA9ICJvcGVuTVBJIiwKfSwKbVQgPSB7Cmh3bG9jID0gewpmbiA9ICIvb3JmZW8vb3B0L21vZHVsZXMvdG9vbHMvaHdsb2MvMi4xMi4wLmx1YSIsCmZ1bGxOYW1lID0gImh3bG9jLzIuMTIuMCIsCmxvYWRPcmRlciA9IDEsCnByb3BUID0ge30sCnJlZl9jb3VudCA9IDEsCnN0YWNrRGVwdGggPSAxLApzdGF0dXMgPSAiYWN0aXZlIiwKdXNlck5hbWUgPSAiaHdsb2MvMi4xMi4wIiwKd1YgPSAiMDAwMDAwMDAyLjAwMDAwMDAxMi4qemZpbmFsIiwKfSwKb3Blbk1QSSA9
-LD_LIBRARY_PATH=/opt/programs/openMPI/5.0.5/lib:/opt/programs/hwloc/2.12.0/lib
+_ModuleTable001_=X01vZHVsZVRhYmxlXyA9IHsKTVR2ZXJzaW9uID0gMywKY19yZWJ1aWxkVGltZSA9IGZhbHNlLApjX3Nob3J0VGltZSA9IGZhbHNlLApkZXB0aFQgPSB7fSwKZmFtaWx5ID0ge30sCm1UID0ge30sCm1wYXRoQSA9IHsKIi9vcmZlby9vcHQvbW9kdWxlcy90b29scyIsICIvb3JmZW8vb3B0L21vZHVsZXMvbXBpIiwgIi9vcmZlby9vcHQvbW9kdWxlcy9saWJyYXJpZXMiLCAiL2V0Yy9tb2R1bGVmaWxlcyIsICIvdXNyL3NoYXJlL21vZHVsZWZpbGVzL0xpbnV4IiwgIi91c3Ivc2hhcmUvbW9kdWxlZmlsZXMvQ29yZSIsCn0sCnN5c3RlbUJhc2VNUEFUSCA9ICIvZXRjL21vZHVsZWZpbGVzOi91c3Ivc2hhcmUvbW9kdWxlZmlsZXM6L3Vzci9zaGFyZS9tb2R1bGVmaWxlcy9MaW51eDov
 XDG_RUNTIME_DIR=/run/user/1159400250
-LMOD_FAMILY_MPI_VERSION=5.0.5
 SSH_CLIENT=195.14.102.43 51241 22
 DEBUGINFOD_URLS=https://debuginfod.fedoraproject.org/
 LC_TIME=en_GB.UTF-8
-LMOD_FAMILY_MPI=openMPI
 DEBUGINFOD_IMA_CERT_PATH=/etc/keys/ima:
-MPI_MAN=/opt/programs/openMPI/5.0.5/share/man
-PATH=/opt/programs/openMPI/5.0.5/bin:/opt/programs/hwloc/2.12.0/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
+PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
 MODULEPATH=/orfeo/opt/modules/tools:/orfeo/opt/modules/mpi:/orfeo/opt/modules/libraries:/etc/modulefiles:/usr/share/modulefiles/Linux:/usr/share/modulefiles/Core
-_LMFILES_=/orfeo/opt/modules/tools/hwloc/2.12.0.lua:/orfeo/opt/modules/mpi/openMPI/5.0.5.lua
 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1159400250/bus
 LMOD_CMD=/usr/share/lmod/lmod/libexec/lmod
 MAIL=/var/spool/mail/jsalvalaggio
 SSH_TTY=/dev/pts/48
-__LMOD_REF_COUNT_LD_LIBRARY_PATH=/opt/programs/openMPI/5.0.5/lib:1;/opt/programs/hwloc/2.12.0/lib:1
-LMOD_FAMILY_HWLOC_VERSION=2.12.0
 LC_NUMERIC=en_GB.UTF-8
 BASH_FUNC_ml%%=() {  eval "$($LMOD_DIR/ml_cmd "$@")"
 }
```
</details>

The command diff -u file_a file_b commands returns a the modification you need to apply to file_a in order to obtain the content of file_b. In this context the - signs indicate a line which is removed while the + signs indicate an new added line. Usually when a line is modified you will see the deleted row and a brand new row with the updated content.

This way, you can see that loading the module has added and modified a list of environmental variables to allow you to invoke its associated commands.

</details>


### `module list`

To keep track of the loaded modules `module list` show all currently loaded modules.
A shortcut of 'module list' is simply 'ml'

```
Currently Loaded Modules:
  1) hwloc/2.12.0   2) openMPI/5.0.5
```

### `module unload`
If for some reason the user need to unload some software, the command `module unload <module name>` will do the trick. 

*Exercise:* Try to unload the openMPI module and verify that the module is effectively unloaded by inspecting your environment variables and also by checking the output of the command 'module list'

### `module purge`

If a lot of modules are loaded or a refresh of the environment is necessary, 
`module purge` unload all currently loaded modules. 

## Loading a different module version

If one version of a module is loaded, there is no need to unload it before loading a different version, as the switch will be handled automatically.
```console
jsalvalaggio@login01:~$ module load openMPI/5.0.5 
jsalvalaggio@login01:~$ module load openMPI/4.1.6 

The following have been reloaded with a version change:
  1) openMPI/5.0.5 => openMPI/4.1.6
```

## Create your own module


In addition to using the modules made available to all users, you can also create your own custom modules.
This is useful for all those situations where you want to install software that is not available in the cluster.

Creating a form occurs in 3 main phases:

- *Software compilation*: you donwload the software and if needed you built it (e.g. compiling from source)
- *Installation*: you store the result of the compilation in a dedicated folder where you have enought privileges to make modifications
- *Creation of a module file**: specify in a file which modification to perform to the envirnoment when the module is loaded.

***Pratical example with python:***

In the login at the moment we have installed python3.13

```
ipasia00@login01:~$ python3 --version
Python 3.13.3
```

Let's assume that for some reason we need to work exactly with `python3.8`, which, as you can see, is not available:

```
ipasia00@login01:~$ python3.8
-bash: python3.8: command not found
```

**Step 1: software compilation**

Let's download `python3.8` from the [official website](https://www.python.org/), and built it. (Don't worry if some of those commands are not clear up to now, they will be explained in depth during the course)

```console
ipasia00@login01:~$ mkdir -p $HOME/src
ipasia00@login01:~/src$ wget -q  https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
ipasia00@login01:~/src$  tar -xzf Python-3.8.0.tgz
ipasia00@login01:~/src$ cd Python-3.8.0/
ipasia00@login01:~/src/Python-3.8.0$ ./configure  --prefix="$HOME/.local/python/3.8.0" --enable-optimizations CC="gcc -pthread" CXX="g++ -pthread"

ipasia00@login01:~/src/Python-3.8.0$ srun -p THIN -A lade --cpus-per-task=12 --tasks-per-node=1 --mem=30G --time=00:10:00 --pty make -j 12
```

**Step 2: Installation**

The previous step has created in this folder a `python` executable which is already usable; however is better to install in a dedicated folder in case we remove the downloaded source code.

```
ipasia00@login01:~/src/Python-3.8.0$ srun -p THIN -A lade --cpus-per-task=1 --tasks-per-node=1 --mem=3G --time=00:10:00 --pty make install
```

This will be install all the binaries and libraries in the `$HOME/.local/python/3.8.0` folder:

```console
ipasia00@login01:~$ ls $HOME/.local/python/3.8.0/
bin  include  lib  share
```

**Step 3 Creation of a module file**

Now we will create a special file to beeing able to load the built python with `modules`.

`modules` search all the files in a special environment variable called `MODULEPATH`, so the first step (should be done only for the first module you built) is to add a new folder to that variable

```console
ipasia00@login01:~$ mkdir -p $HOME/.local/modules/
ipasia00@login01:~$ echo "export $MODULEPATH=$MODULEPATH:$HOME/.local/modules" >> $HOME/.bashrc
ipasia00@login01:~$ source $HOME/.bashrc
```

And we will create a file in `$HOME/.local/modules/python/3.8.0.lua` with the following content:


<details>
<summary>$HOME/.local/modules/python/3.8.0.lua</summary>
```lua
-- -*- lua -*-

local name      = "python"
local version   = "3.8.0"
whatis("Name         : " .. name)
whatis("Version      : " .. version)
whatis("Description  : Python 3.8.0 module")

-- Dependency if needed
-- depends_on("<module_name>")

-- Directory where is installed
local home = os.getenv("HOME") .. "/.local/python/" .. version

prepend_path("PATH", home .. "/bin")

setenv("PYTHON_HOME", home)

-- Info message displayed
if (mode() == "load") then
    LmodMessage("Loaded " .. name .. " " .. version)
    LmodMessage("Available commands: python3, pip3")
end
```
</details>


Now as you see a new module is available:

```console
ipasia00@login01:~$ module avail
----------------------------------------- /u/area/ipasia00/.local/modules -----------------------------------------
   python/3.8.0
```

And if loaded, the python interpreter changes!

```console
ipasia00@login01:~$ module load python/3.8.0
Loaded python 3.8.0
Available commands: python3, pip3

ipasia00@login01:~$ python3 --version
Python 3.8.0

ipasia00@login01:~$ which python3
~/.local/python/3.8.0/bin/python3

ipasia00@login01:~$ which pip3
~/.local/python/3.8.0/bin/pip3
```


<br>
Authors: Isac Pasianotto, Jacopo Salvalaggio, Niccolò Tosato, Stefano Cozzini

