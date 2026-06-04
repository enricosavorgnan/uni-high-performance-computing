---
icon: material/console
---

# Bash cheat sheet

This tutorial serves as a crash course in the basics of bash, as well as a reminder or reference for commands you may already know.
It is meant to be concise but at the same time give helpful tips on the fundamentals of using the terminal.
Feel free to leave suggestions on things you or others might find useful!

!!! tip "Further reading"

    Some more in-depth resources:

    + [GNU Bash manual](https://www.gnu.org/software/bash/manual/)
    + [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/)
    + ...

## Bash basic commands

### Manual pages

#### `man`

`man` is your interface with the system manual.
Often, the answers to many questions can be easily found here, without the need to look them up elsewhere.
While many commands have something similar to a `-h, --help` flag that lists most common options, the manual is meant to be a complete reference for said command.
The basic syntax is `man <name of some command>`.

??? example "Examples"

    Let us look at what the output of the `man` command looks like, for example by taking a look at the manual's manual with `man man`:
    ```less
    MAN(1)                         Manual pager utils                        MAN(1)

    NAME
           man - an interface to the system reference manuals

    SYNOPSIS
           man [man options] [[section] page ...] ...
           man -k [apropos options] regexp ...
           man -K [man options] [section] term ...
           man -f [whatis options] page ...
           man -l [man options] file ...
           man -w|-W [man options] page ...

    DESCRIPTION
           man  is  the  system's manual pager.  Each page argument given to man is
           normally the name of a program, utility or function.   The  manual  page
           associated  with each of these arguments is then found and displayed.  A
           section, if provided, will direct man to look only in  that  section  of
           the  manual.   The  default  action is to search in all of the available
           sections following a pre-defined order (see DEFAULTS), and to show  only
           the first page found, even if page exists in several sections.

     Manual page man(1) line 1 (press h for help or q to quit)
    ```
    The man page describes the command: what it does, what are the options you can pass to it and often some examples.
    By default, the page will open through the command `less` (see [below](#less) or type ++h++ for a list of navigation commands).

    Try to explore some man pages yourself.
    For example, going down the `man` manual, you will find the guide on its usage and options:
    ```less
    OPTIONS
            Non-argument options that are duplicated either on the command line, in
       $MANOPT, or both, are not harmful.  For options that require  an  argu‐
       ment, each duplication will override the previous argument value.

       General options
           -C file, --config-file=file
                  Use  this  user  configuration  file  rather than the default of
                  ~/.manpath.

           -d, --debug
                  Print debugging information.

           -D, --default
                  This option is normally issued as the very first option and  re‐
                  sets  man's behaviour to its default.  Its use is to reset those
                  options that may have been set in  $MANOPT.   Any  options  that
                  follow -D will have their usual effect.

           --warnings[=warnings]
                  Enable  warnings from groff.  This may be used to perform sanity
                  checks on the source text of manual pages.  warnings is a comma-
     Manual page man(1) line 184 (press h for help or q to quit)
    ```

!!! tip "Related commands"

    Here is a list of related commands:

    + `whatis <name of some command>` displays a very brief description of a command;
    + `apropos <keyword>` lists all man pages related to a keyword (can be very handy!);
    + `info` is an alternative command to access man pages.


### Accessing and inspecting directories

#### `pwd`

`pwd` is the command to use to print your location in the filesystem of the computer, i.e. your current directory (whose name in the terminal is `.`).
```console
jsalvalaggio@login01:~$ pwd
/u/area/jsalvalaggio
```

#### `realpath`

`realpath <file>` provides the absolute path to a file.
```console
jsalvalaggio@login01:~$ realpath .
/orfeo/cephfs/home/area/jsalvalaggio
jsalvalaggio@login01:~$ realpath Test/
/orfeo/cephfs/home/area/jsalvalaggio/Test
```

!!! tip "Symbolic links"

    A symbolic link (symlink) is a link to the path to a file or a directory.
    It can be very useful as it allows you to create a "fake" copy of a file in any location, and that symbolic copy will always be up-to-date with any edits made to the original while occupying (almost) no memory.
    Notice how the output of `pwd` and of `realpath .` are not the same, even if one could expect them to be, as they both print the path to the current directory.
    The reason of this is that `pwd` does not resolve symbolic links by default, so it will print the name of the symbolic link instead of the name of the original linked file.
    You can override this with the `-P, --physical` flag:
    ```console
    jsalvalaggio@login01:~$ pwd -P
    /orfeo/cephfs/home/area/jsalvalaggio
    ```
    You can inspect the link of a symlink with the `readlink` command.
    ```console
    jsalvalaggio@login01:~$ readlink /u
    /orfeo/cephfs/home/
    ```

#### `ls`

`ls <dir>` lists the contents of a directory.
If no arguments are passed, it will show the contents of the working directory.
On my home directory the command returns:
```console
jsalvalaggio@login01:~$ ls
Code       env_after   fast     ondemand    sbatch_script.sh  some_script.sh
Documents  env_before  hello.x  py_test.py  scratch
```
`ls` has many options that change the type and order of information shown to the user.
These are, in my opinion, some of the most useful:

+ `-A, --almost-all`, list all files, including hidden files, but not current and parent directory `./` and `../`;
+ `-l`, use long listing format, i.e. print a bunch of info such as permissions, size, creation time;
+ `-s, --size`, print information on size in bytes (note, it will not actually count the size of the contents of a directory, for that you will need a different command, `du`);
+ `-h, --human-readable`, display size in human-readable format (e.g. 1024 -> 1K);
+ `-S`, sort by size;
+ `-t`, sort by time (creation time by default, but it can be changed via the `--time` option);
+ `-r, --reverse`, reverse sort order;
+ `-I, --ignore=<pattern>`, ignore a certain pattern (see the [bash wildcards section](#bash-wildcards) below);
+ `-1`, format output in one column.

??? example "Examples"

    Print files in order of creation time, with the last one on the bottom:
    ```console
    jsalvalaggio@login01:~$ ls -1 -tr
    fast
    scratch
    ondemand
    Documents
    env_before
    env_after
    py_test.py
    sbatch_script.sh
    some_script.sh
    Code
    hello.x
    ```

    Print size information in human-readable form and sort by it, biggest files on top:
    ```console
    jsalvalaggio@login01:~$ ls -1 -shS 
    total 16K
    7.0K env_after
    5.5K env_before
     512 sbatch_script.sh
     512 scratch
     512 fast
     512 py_test.py
     512 hello.x
     512 some_script.sh
       0 Code
       0 Documents
       0 ondemand
    ```

    Print a lot of information, sort by creation time and ignore files ending in `.sh`:
    ```console
    jsalvalaggio@login01:~$ ls -lt --ignore=*.sh
    total 15
    lrwxrwxrwx 1 jsalvalaggio jsalvalaggio   22 Feb 12 16:34 hello.x -> Code/HPCCourse/hello.x
    drwxr-xr-x 4 jsalvalaggio jsalvalaggio    2 Feb  4 17:14 Code
    -rw-r--r-- 1 jsalvalaggio jsalvalaggio   23 Feb  3 14:48 py_test.py
    -rw-r--r-- 1 jsalvalaggio jsalvalaggio 7149 Feb  3 11:04 env_after
    -rw-r--r-- 1 jsalvalaggio jsalvalaggio 5355 Feb  3 11:04 env_before
    drwxr-xr-x 3 jsalvalaggio jsalvalaggio    1 Jan 27 11:05 Documents
    drwxr-xr-x 3 jsalvalaggio jsalvalaggio    1 Dec 11 11:45 ondemand
    lrwxrwxrwx 1 root         root           39 Dec  9 14:11 scratch -> /orfeo/cephfs/scratch/area/jsalvalaggio
    lrwxrwxrwx 1 root         root           36 Dec  9 14:11 fast -> /orfeo/cephfs/fast/area/jsalvalaggio
    ```

!!! tip "Hidden files"

    You can hide files from the standard `ls` output (i.e. when no `-a, --all` or `-A, --almost-all` flag are used) by putting a `.` in front of the file name.
    So, a file named `some_file` will show up when invoking default `ls` but `.some_file` will not.

!!! tip "Creating an empty file"

    Sometimes, for instance for the purpose of trying these examples on your own shell, you might want to create an empy file, simply a new addition to what `ls` prints but without any content.
    To do that, you can use the `touch` command:
    ```console
    jsalvalaggio@login01:~/Test$ ls
    SomeDir  some_file.txt
    jsalvalaggio@login01:~/Test$ touch some_new_file.txt
    jsalvalaggio@login01:~/Test$ ls
    SomeDir  some_file.txt  some_new_file.txt
    ```

#### `cd`

`cd` is used to change the working directory.
Usage is `cd <path to dir>` to access the selected directory.
`cd -` goes back to the last visited directory (before the one you currently find yourself in).
```console
jsalvalaggio@login01:~$ pwd
/u/area/jsalvalaggio
jsalvalaggio@login01:~$ cd Code/
jsalvalaggio@login01:~/Code$ pwd
/u/area/jsalvalaggio/Code
jsalvalaggio@login01:~/Code$ cd -
/u/area/jsalvalaggio
jsalvalaggio@login01:~$ pwd
/u/area/jsalvalaggio
```
Note that `cd <some dir>` and `cd <some dir>/` will have the same effect.
The `/` at the end just serves to communicate we are looking at a directory and not a simple file that cannot be `cd`'ed into.

!!! tip "Current and parent directory"

    As mentioned earlier, the current directory is labelled in your shell as `.`, so `cd .` will move you to the directory where you are already in (i.e. it will do nothing).
    The parent directory, namely the one that contains the one you are in, is indicated as `..`.
    You can use it to move up the directory tree:
    ```console
    jsalvalaggio@login01:~/Test$ pwd
    /u/area/jsalvalaggio/Test
    jsalvalaggio@login01:~/Test$ cd ../
    jsalvalaggio@login01:~$ pwd
    /u/area/jsalvalaggio
    ```

#### `mkdir`

`mkdir <dir name>` creates a directory.
Use flag `-p, --parents` to create nested directory in one go.
```console
jsalvalaggio@login01:~/Test$ mkdir SomeDir
jsalvalaggio@login01:~/Test$ ls
SomeDir
jsalvalaggio@login01:~/Test$ mkdir AnotherDir/AnyDir
mkdir: cannot create directory ‘AnotherDir/AnyDir’: No such file or directory
jsalvalaggio@login01:~/Test$ mkdir -p AnotherDir/AnyDir
jsalvalaggio@login01:~/Test$ ls AnotherDir/
AnyDir
```


### Copying, moving and deleting files

#### `cp`

`cp <existing file> <new file>` creates a copy of a new file in a new destination.
If the second argument is the name of a directory, the existing file will be copied in that directory keeping the same file name.
Some useful options are 

+ `-R, -r, --recursive`, copy the contents of a directory recursively (necessary when copying non-empty directories);
+ `-i, --interactive`, show message before overwriting a file;
+ `-s, --symbolic-link`, create a symbolic link instead of copying (it is best to use absolute paths for the source file when doing this);

??? example "Examples"

    We start from the `Test/` directory:
    ```console
    jsalvalaggio@login01:~/Test$ ls
    SomeDir  some_file.txt
    ```

    Copy a file into a new file with a different name:
    ```console
    jsalvalaggio@login01:~/Test$ cp some_file.txt some_new_file.txt
    jsalvalaggio@login01:~/Test$ ls
    SomeDir  some_file.txt  some_new_file.txt
    ```

    Make a symbolic link of a file in a directory, keeping the file name:
    ```console
    jsalvalaggio@login01:~/Test$ cp -s /orfeo/cephfs/home/area/jsalvalaggio/Test/some_file.txt SomeDir/
    jsalvalaggio@login01:~/Test$ ll SomeDir/
    total 1
    lrwxrwxrwx 1 jsalvalaggio jsalvalaggio 55 Feb 13 15:52 some_file.txt -> /orfeo/cephfs/home/area/jsalvalaggio/Test/some_file.txt
    ```
    Notice how we *had* to provide the absolute path to the file for creating the symlink, providing the path relative to the `Test/` directory returns an error.

    Copy a file in interactive mode:
    ```console
    jsalvalaggio@login01:~/Test$ cp -i some_file.txt some_newer_file.txt 
    jsalvalaggio@login01:~/Test$ cp -i some_newer_file.txt some_file.txt 
    cp: overwrite 'some_file.txt'?
    ```
    The first time, when creating `some_newer_file.txt` for the first time, no prompt is shown.
    However the second time, when `cp` sees we are trying to overwrite an existing file, the `-i` flag allows us to verify we are doing the correct thing by asking us if we really want to proceed.
    If the answer is positive, tipe ++y++, otherwise ++n++, then ++enter++.

#### `mv`

`mv <existing file> <new location>` moves a file to a new path.
It is also used to rename files.
Like `cp`, it supports the `-i, --interactive` flag to make sure you are not overwriting any existing files.

#### `rm`

`rm <existing file>` deletes a file.
Again, it supports the `-i, --interactive` flag and also the `-r, --recursive` flag in order to remove non-empty directories recursively.


### Printing to the terminal

#### `cat`

`cat` is used to print the contents of a file in the terminal.
The syntax is `cat <file name>`
```console
jsalvalaggio@login01:~$ cat some_file.txt 
This is the content of a random file.
Hello, world!
```

!!! tip "Printing file length"
    
    You can retrieve information on the length of a file with the `wc` command.
    By default, it will print line, word and character count.
    ```console
    jsalvalaggio@login01:~$ wc some_script.sh 
     13  34 327 sbatch_script.sh
    ```


#### `echo`

`echo` is the basic command to print any string of text to the terminal.
The syntax is `echo <string you want to output>`
```console
jsalvalaggio@login01:~$ echo Hello, world!
Hello, world!
```

!!! tip "Redirecting output"

    You can use `echo` (or any other command that outputs to the terminal for that matter) to write text to a file by redirecting its output via the `>` and `>>` operators.
    The former will overwrite the contents of the file with the new lines, while the latter will append the output after what was already present in that file.
    The syntax is `<command> > <file name>` or `<command> >> <file name>`.
    <!-- (we will go over this again in more detail [later](#redirecting)) -->
    ```console
    jsalvalaggio@login01:~$ echo Hello, world! > new_file.txt
    jsalvalaggio@login01:~$ cat new_file.txt 
    Hello, world!
    jsalvalaggio@login01:~$ echo I am overwriting... > new_file.txt 
    jsalvalaggio@login01:~$ cat new_file.txt 
    I am overwriting...
    jsalvalaggio@login01:~$ echo I am appending... >> new_file.txt 
    jsalvalaggio@login01:~$ cat new_file.txt 
    I am overwriting...
    I am appending...
    jsalvalaggio@login01:~$ pwd > new_file.txt 
    jsalvalaggio@login01:~$ cat new_file.txt 
    /u/area/jsalvalaggio
    ```

<!--
A pager is a program to display the contents of a file (or of output) as a scrollable stream on the terminal.
Fundamentally, there are two widely-used pagers installed on ORFEO, `more` and `less`.

#### `more`
-->

#### `head` and `tail`

The `cat` command outputs the whole content of a file on the terminal; this can be a bit hard to handle if the file is particularly large.
Here is where `head` and `tail` come in, displaying respectively the first and last lines of the file alone.
The default number of lines is 10, but can be changed with the `-n, --lines=<number>` option.

??? example "Examples"

    We start from a file with 20 lines:
    ```console
    jsalvalaggio@login01:~$ cat some_file.txt 
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    ```

    Display the first or last lines with `head` and `tail`:
    ```console
    jsalvalaggio@login01:~$ head some_file.txt 
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    jsalvalaggio@login01:~$ tail some_file.txt 
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    ```

    Control the number of lines shown in output:
    ```console
    jsalvalaggio@login01:~$ tail -n 4 some_file.txt 
    17
    18
    19
    20
    ```

!!! tip "Following the end of a changing file"

    You can follow the end of a changing file via the `-f, --follow` of `tail`.
    I find it pretty useful to keep track of log files that are being written by some code or script, such as the output file of a `sbatch` script (see the [tutorial on SLURM](using_slurm.md)).

#### `less`

Sometimes you want to inspect a file (or output) in a scrollable fashion, something that the aforementioned commands cannot do.
For this you need what is called a *pager*, and we will here describe a specific pager named `less` (if you are really curious about pagers, as I suspect you definitely are, you can also check out `more`).
We have already shown some output from this command earlier when we described `man`, as it uses `less` by default.
Opening a file with less (`less <file name>`) will create a window on the terminal where you can navigate its contents easily (or, at the very least, more easily then with `cat`).
You can scroll with ++arrow-up++ ++arrow-down++ ++arrow-left++ ++arrow-right++ as well as ++page-up++ ++page-down++ ++home++ and ++end++.
To search forwards or backwards for a word in the text, type ++slash++ or ++question++ respectively followed by the desired string and finally ++enter++.
To move down and up the occurrences of said word, use ++n++ and ++shift+n++ respectively.
Type ++h++ for help and ++q++ to quit.

!!! tip "Pipelines"

    The command `less` wants a file as input to display.
    However, it is often useful to invoke it to make long outputs more easily read.
    For that, you can use a *pipeline*, a handy bash construct to redirect output of a command as input of another.
    Without going too much into details <!-- (we will talk about this again [later](#redirecting)) --> the syntax to do this is `<command> | less`.



### Text editors

Text editors can be seen as improved pagers: they let you inspect files but also edit them like you would do in, say, Word.
A number of text editors come installed on ORFEO, such as `nano`, `emacs` and `vim`.
The basic command to open a file with them is `<editor name> <file name>` (e.g. `vim notes.txt`).
Often, it is hard to exit these programs once one ends up inside them by mistake, so let us recap how to do that for all of them before giving some extra details on `vim`:

+ `nano`: exit with ++ctrl+x++;
+ `emacs`: exit with ++ctrl+x++, ++ctrl+c++;
+ `vim`: exit with ++esc++, type `:q!` and finally ++enter++;

#### `vim`

`vim` is a modal text editor.
That means there are different *modes* you can be in and the editor will respond differently to keystrokes depending on the mode that is currently active.

The most important mode is *insert mode*, which allows you to actually write stuff in the file.
You can access it with ++i++; you can verify if you are in this mode by checking if `-- INSERT --` is written at the bottom of the page.
When in insert mode, you can type as you would in a "normal" text editor on your computer.
To exit the mode, type ++esc++.

To select text, move to *visual mode* with ++v++.
You can cut the selected text with ++d++ or copy it with ++y++ and then paste it with ++p++.

Finally, from the "default" mode (type ++esc++ to be sure you are there) you can run commands (all followed by ++enter++):

+ search forwards and backwards with `/<string>` and `?<string>` respectively (you can also use regular expressions, see [below](#regular-expressions-and-grep));
+ move to the next (previous) search result with `n` (`N`);
+ save with `:w` (you can also do `:w <file name>` to save as);
+ open a new file with `:o <file name>` (or a new tab with `:tabe <file name>`);
+ move through open files with `:n` and `:N` (or through open tabs with `gt` and `gT`, no ++enter++ on these ones!);
+ quit with `:q` (`:q!` if you want to force quit, i.e. discard any non-saved changes).
 


### Shell environment

Every shell session is defined by a set of environmental variables, i.e. quantities that define the state of the shell by specifying, among others, the name of the user and of the host as well as the path to the executable commands.

#### `export`

You can use `export` to add environmental variables or edit existing ones.
Unlike variables declared in the shell via `#!console $ my_var=<some value>`, environmental variables are accessible by subprocesses (e.g. a bash script).
So, you can define your custom environmental variables via `export MY_VAR=<some value>`[^1] so that they can be used in scripts.

??? example "Example"

    Here is a script that looks for an variable defining the default python environment (not among the default environmental variables of bash):
    ```bash title="do_something.sh"
    #!/bin/bash
    # Activate python env
    source ${DEFAULT_PYENV}/bin/activate
    # Do more stuff
    echo Doing something...
    ```
    It will return an error if run without first properly defining `DEFAULT_PYENV`, but it will run normally if it is first exported.
    ```console
    jsalvalaggio@login01:~$ sh do_something.sh 
    do_something.sh: line 3: /bin/activate: No such file or directory
    jsalvalaggio@login01:~$ DEFAULT_PYENV=/u/area/jsalvalaggio/.venv/base/
    jsalvalaggio@login01:~$ sh do_something.sh 
    do_something.sh: line 3: /bin/activate: No such file or directory
    jsalvalaggio@login01:~$ export DEFAULT_PYENV=/u/area/jsalvalaggio/.venv/base/
    jsalvalaggio@login01:~$ sh do_something.sh 
    Doing something...
    ```

#### `whoami`

`whoami` prints the name of the user invoking the command.
```console
jsalvalaggio@login01:~$ whoami
jsalvalaggio
```

!!! tip "Accessing the value of a variable"

    We can obtain a similar result to the one shown in the code snippet above by printing the value of the environmental variable storing the username, `USER`.
    In order to access the value of any bash shell variable, we must add a dollar sign in front of it:
    ```console
    jsalvalaggio@login01:~$ echo $USER 
    jsalvalaggio
    ```

#### `hostname`

`hostname` prints the name of the host of the session.
Can be rather useful to check which node we are using in a cluster.
```console
jsalvalaggio@login01:~$ hostname
login01.hpc.rd.areasciencepark.it
```

#### `env`

`env` is used to run commands in a modified shell environment.
If no command argument is provided, it prints out all environmental variables and their value.



### Pattern matching and regular expressions

Often, when looking for files in our computer or when inspecting a document, we want to look for all names and strings that match a particular pattern.
For instance, imagine you need to fetch all file names ending with `.sh` or all lines in a python code starting with `def`.
This is done via the syntax of pattern matching. 

#### Bash wildcards

Bash provides a set of handy special characters to be used for pattern matching when listing files on the terminal.
Here is a non-comprehensive list of the most useful use cases:

+ `*` matches any string, even an empty one;
+ `?` matches any single character (not an empty one, though!);
+ `[...]` matches any character within the brackets;
+ `[!...]` matches any character not withing the brackets.

??? example "Examples"

    Here are the contents of a sample directory:
    ```console
    jsalvalaggio@login01:~$ ls
    Code       env_before  less          output_2.out  sbatch_script.sh  some_script.sh
    Documents  fast        ondemand      output_3.out  scratch           Test
    env_after  hello.x     output_1.out  py_test.py    some_file.txt
    ```

    List any file containing a `.` (note: this will ignore hidden files)
    ```console
    jsalvalaggio@login01:~$ ls *.*
    hello.x       output_2.out  py_test.py        some_file.txt
    output_1.out  output_3.out  sbatch_script.sh  some_script.sh
    ```

    List any file containing a `.` or `_`
    ```console
    jsalvalaggio@login01:~$ ls *[._]*
    env_after   hello.x       output_2.out  py_test.py        some_file.txt
    env_before  output_1.out  output_3.out  sbatch_script.sh  some_script.sh
    ```

    List any bash script, i.e. any file ending in `.sh`
    ```console
    jsalvalaggio@login01:~$ ls *.sh
    sbatch_script.sh  some_script.sh
    ```

    List all files and directories containing or beginning with (remember, `*` also matches an empty string) the character `o`
    ```console
    jsalvalaggio@login01:~$ ls *o*
    env_before  hello.x  output_1.out  output_2.out  output_3.out  some_file.txt  some_script.sh

    Code:
    HPCCourse  Learn

    Documents:
    Foundations_of_HPC_2022

    ondemand:
    data
    ```

    List all files of the form `output_<a digit>.out`; then delete them
    ```console
    jsalvalaggio@login01:~$ ls output_?.out 
    output_1.out  output_2.out  output_3.out
    jsalvalaggio@login01:~$ rm -i output_?.out 
    rm: remove regular empty file 'output_1.out'? y
    rm: remove regular empty file 'output_2.out'? y
    rm: remove regular empty file 'output_3.out'? y
    ```
    Note: always **be very careful** deleting groups of files with wildcards.
    Always make sure you are not including any file that you do not want deleted!
    The interactive flag is your friend here.

#### Regular expressions and `grep`

Regular expressions (regex) are a more advanced variety of pattern matching with respect to bash wildcards; they allow you to perform rather sophisticated searches with strings.
One useful context where to use them is `grep`, a command that allows you to look for patterns within files.
The syntax is `grep [options] <regex pattern> <file or directory name>`.
By default, `grep` will print all lines of the file(s) where the pattern is matched.
Useful options are:

+ `-r, --recursive` search recursively into directories;
+ `-i, --ignore-case` ignore lower/upper case distinction.

`grep` regular expressions differ from the wildcards we have seen above.
Here are some examples:

+ `.` matches any single character;
+ `*` matches zero or more repetitions of the preceding character;
+ `^` and `$` specify the pattern is at the beginning or at the end of a line, respectively.

More broadly, regular expressions differ from wildcards because they will return a match with *anything* containing the string: if, in order to list all files ending with `.sh` we earlier had to write `*.sh` (as `.sh` alone would *only* have matched that exact three-character string), with grep we now just need to write `.sh` (or `.sh$` to specify we want to end with that pattern).

??? example "Examples"

    `env_output` is a file containing the output of the rather verbose `env` command.
    You can create one youself by copy-pasting or redirecting said output in a new file.
    ```console
    jsalvalaggio@login01:~$ cat env_output 
    SHELL=/bin/bash
    HISTCONTROL=ignoredups
    HISTSIZE=1000
    HOSTNAME=login01.hpc.rd.areasciencepark.it
    FPATH=/usr/share/lmod/lmod/init/ksh_funcs
    LC_ADDRESS=en_GB.UTF-8
    _ModuleTable002_=dXNyL3NoYXJlL21vZHVsZWZpbGVzL0NvcmU6L3Vzci9zaGFyZS9sbW9kL2xtb2QvbW9kdWxlZmlsZXMvQ29yZSIsCn0K
    LC_NAME=en_GB.UTF-8
    __LMOD_REF_COUNT_MODULEPATH=/orfeo/opt/modules/tools:1;/orfeo/opt/modules/mpi:1;/orfeo/opt/modules/libraries:1;/etc/modulefiles:1;/usr/share/modulefiles/Linux:1;/usr/share/modulefiles/Core:1
    LC_MONETARY=en_GB.UTF-8
    [...]
    ```

    Show all lines in `env_output` containing the string `PATH`
    ```console
    jsalvalaggio@login01:~$ grep 'PATH' env_output 
    FPATH=/usr/share/lmod/lmod/init/ksh_funcs
    __LMOD_REF_COUNT_MODULEPATH=/orfeo/opt/modules/tools:1;/orfeo/opt/modules/mpi:1;/orfeo/opt/modules/libraries:1;/etc/modulefiles:1;/usr/share/modulefiles/Linux:1;/usr/share/modulefiles/Core:1
    MANPATH=/usr/share/lmod/lmod/share/man::
    __LMOD_REF_COUNT_PATH=/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1
    MODULEPATH_ROOT=/usr/share/modulefiles
    __LMOD_REF_COUNT_MANPATH=/usr/share/lmod/lmod/share/man:1;:1
    DEBUGINFOD_IMA_CERT_PATH=/etc/keys/ima:
    PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
    MODULEPATH=/orfeo/opt/modules/tools:/orfeo/opt/modules/mpi:/orfeo/opt/modules/libraries:/etc/modulefiles:/usr/share/modulefiles/Linux:/usr/share/modulefiles/Core
    ```

    Show all lines starting with the string `PATH`
    ```console
    jsalvalaggio@login01:~$ grep '^PATH' env_output 
    PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
    ```

    Show all lines in `env_output` containing an `=` sign, followed by any string and then a `/`
    ```console
    jsalvalaggio@login01:~$ grep '=.*/' env_output 
    SHELL=/bin/bash
    FPATH=/usr/share/lmod/lmod/init/ksh_funcs
    __LMOD_REF_COUNT_MODULEPATH=/orfeo/opt/modules/tools:1;/orfeo/opt/modules/mpi:1;/orfeo/opt/modules/libraries:1;/etc/modulefiles:1;/usr/share/modulefiles/Linux:1;/usr/share/modulefiles/Core:1
    GPG_TTY=/dev/pts/48
    LMOD_DIR=/usr/share/lmod/lmod/libexec
    EDITOR=/usr/bin/vim
    PWD=/u/area/jsalvalaggio
    MODULESHOME=/usr/share/lmod/lmod
    MANPATH=/usr/share/lmod/lmod/share/man::
    __LMOD_REF_COUNT_PATH=/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1
    HOME=/u/area/jsalvalaggio
    MODULEPATH_ROOT=/usr/share/modulefiles
    LMOD_PKG=/usr/share/lmod/lmod
    LESSOPEN=||/usr/bin/lesspipe.sh %s
    LMOD_ROOT=/usr/share/lmod
    BASH_ENV=/usr/share/lmod/lmod/init/bash
    __LMOD_REF_COUNT_MANPATH=/usr/share/lmod/lmod/share/man:1;:1
    XDG_RUNTIME_DIR=/run/user/1159400250
    DEBUGINFOD_URLS=https://debuginfod.fedoraproject.org/ 
    DEBUGINFOD_IMA_CERT_PATH=/etc/keys/ima:
    PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
    MODULEPATH=/orfeo/opt/modules/tools:/orfeo/opt/modules/mpi:/orfeo/opt/modules/libraries:/etc/modulefiles:/usr/share/modulefiles/Linux:/usr/share/modulefiles/Core
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1159400250/bus
    LMOD_CMD=/usr/share/lmod/lmod/libexec/lmod
    MAIL=/var/spool/mail/jsalvalaggio
    SSH_TTY=/dev/pts/48
    BASH_FUNC_ml%%=() {  eval "$($LMOD_DIR/ml_cmd "$@")"
    _=/usr/bin/env
    ```


[^1]: Here I have adhered to the naming convention of keeping environmental variables all caps while using lowercase for all other variables.

<br>
Authors: Jacopo Salvalaggio
