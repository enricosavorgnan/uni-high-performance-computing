---
icon: material/bash
---

# Bash Scripting

!!! tip "Reference"
    The source of truth when you have any doubt about bash scripting is the [GNU Bash manual](https://www.gnu.org/software/bash/manual/bash.html).

***Why should I learn bash scripting?***

While writing commands interactively in the terminal is fine for simple tasks, it can become tedious and error-prone when you need to perform complex operations or repeat the same commands multiple times. Bash scripting allows you to automate these tasks, making your workflow more efficient and less prone to errors.
Moreover, when working in a HPC environment, you often need to submit jobs to the cluster, without a script, you would need to wait as long as the resourse are available, then write the command to run your job and wait for it to be done. This is obiusly not practical at all.

In this tutorial, we will cover the basics of bash scripting, including how to create and run a bash script, how to use variables and control structures, and how to debug your scripts.

## Prerequisites.

If you are interracting with an HPC cluster, very likely you will have access to a bash shell and no GUI, so you will need to use the terminal to create and run your bash scripts.
The two most common text editors available in the terminal are `nano` and `vim`, you can use either of them to create and edit your bash scripts.

If you are not familiar with these editors, you can check out the following tutorials:

- [Nano tutorial](https://www.nano-editor.org/dist/latest/nano.html)
- [Vim tutorial](https://www.vim.org/docs.php)

**Tip**: If you are stuck with vim, you can  exit pressing ++esc++ and then ++":"++ ++q++ ++"!"++ toquit witohut saving, or ++esc++ ++":"++ ++w++ ++q++ to save and quit.
 

## My first bash script

To create a bash script, you can use any text editor to create a new file. 
For convention, bash scripts usually have the extension `.sh`, thecnically this is not mandatory, but it helps to identify the file as a bash script.
For example, you can create a file called `hello_world.sh` with the following content:

```bash
#!/bin/bash

echo "Hello, World!"
```

which can be executed with the following command:

```console
ipasia00@login01:~$ bash hello_world.sh
Hello, World!
```

??? question "What does the first line of the script do?"
    The first line of the script, `#!/bin/bash`, is called ***shebang***.
    It tells the system which interpreter to use to execute the script. In this case, it tells the system to use the bash shell to execute the script.
    This is important because it ensures that the script will be executed with the correct interpreter, regardless of the user's default shell (e.g., zsh, fish, etc.).

    If you make the script executabile with `chmod +x <script_name>` and run it with `./<script_name>`, the shebang will be used to determine which interpreter to use:

    ```console
    ipasia00@login01:~$ head script1 script2
    ==> script1 <==
    #!/bin/bash

    echo "Hello from Bash"

    ==> script2 <==
    #!/usr/bin/env python3

    print("hello from Python")
    
    ipasia00@login01:~$ chmod +x script1 script2
    ipasia00@login01:~$ ./script1
    Hello from Bash
    ipasia00@login01:~$ ./script2
    hello from Python
    ```

## Variables and control structures

In bash the variable assignment is done with the `=` operator, without spaces around it.

```bash
name="myName"
```
To access the value of a variable, you need to prefix it with a `$` sign. Optionally you can also enclose the variable name in curly braces `{}` which can be useful to avoid ambiguity when the variable name is followed by other characters.

```bash
echo "Hello, $name!"
echo "Hello, ${name}!"
```

To reset the value of a variable, you can use the `unset` command or simply assign an empty string to it:

```bash
unset name
name=""
```

By default, variables in bash are treated as strings, but you can perform arithmetic operations on them using the `let` command or the `(( ))` syntax:

```bash
a=5
b=10

c=${a}+${b}
echo $c  # Output: 5+10

let c=a+b
echo $c  # Output: 15

c=$((a + b))
echo $c  # Output: 15
```

There are some special characters that have a special meaning in bash, such as `*`, `?`, `|`, `&`, etc. If you want to use these characters as part of a string, you need to escape them with a backslash `\` or enclose the string in quotes.
The escaping is necessary to prevent the shell from interpreting these characters as special characters and instead treat them as literal characters.

```bash
echo  *  # Output: lists all files in the current directory
echo \*  # Output: *
echo "*"  # Output: *
```

It also possible to define **arrays** in bash, which are indexed collections of values. The syntax for defining an array is as follows:

```bash
array_name=(value1 value2 value3 ...)
```

To get the value of an array element, you can use the syntax `${array_name[index]}`:

```bash
my_array=(apple banana cherry)
echo ${my_array[0]}  # Output: apple
echo ${my_array[1]}  # Output: banana
```

Note that indicating the array name without an index will return the first element of the array. To get all the elements of the array, you can use the syntax `${array_name[@]}`:

```bash
echo ${my_array}  # Output: apple
echo ${my_array[@]}  # Output: apple banana cherry
```

## Some special variables

Bash has some special variables that are automatically set by the shell and can be used in your scripts. Some of the most commonly used special variables are:

- `$$`: The process ID of the current shell.
- `$?`: The exit status of the last command executed:
  
    - `0` if the command was successful.
    - A non-zero value if the command failed (the specific value depends on the type of error).

```bash
mkdir non_existent_directory
echo $?  # Output: 0
rm non_existent_directory
echo $?  # Output: 1
rm -r non_existent_directory
echo $?  # Output: 0
```

- `$#`: The number of positional parameters passed to the script.
  
    - `$0`: The name of the script itself.
    - `$1`, `$2`, ..., `$9`: The first, second, ..., ninth positional parameters passed to the script.

    ```bash
    #!/bin/bash
    echo "Script name: $0"
    echo "Number of parameters: $#"
    echo "First parameter: $1"
    echo "Second parameter: $2"
    ```
    ```
    ipasia00@login01:~$ bash demo.sh 42 banana
    Script name: demo.sh
    Number of parameters: 2
    First parameter: 42
    Second parameter: banana
    ```

- All the variables declared in the environment (e.g., `PATH`, `HOME`, etc.) which can be listed with the `env` command.



## If statements

Bash supports the `if` statement for conditional execution of commands. The syntax is as follows:

```bash
if [[ condition ]];
then
    # commands to execute if condition is true
fi
```
```bash
if [[ condition ]];
then
    # commands to execute if condition is true
else if [[ condition2 ]];
then
    # commands to execute if condition2 is true
else
    # commands to execute if both conditions are false  
fi
```

The `condition` can be any `conditional expression` that evaluates to true or false or a command that returns an exit status of `0` for true and non-zero for false.

The complete list of conditional expressions can be found in the [GNU Bash manual](https://www.gnu.org/software/bash/manual/bash.html#Shell-Conditional-Expressions), but some of the most commonly used ones are:

- `-f file`: True if the file exists.
- `-d dir`: True if the directory exists.
- `-s file`: True if the file exists and is not empty (size > 0).

It is possible also to combine multiple conditions using the `&&` (logical AND) and `||` (logical OR) operators:

```bash
if [[ -f file1 && -f file2 ]];
then
    echo "Both file1 and file2 exist."
fi
```

```bash
if [[ -f file1 || -f file2 ]];
then
    echo "At least one of file1 or file2 exists."
fi
```

Other example of conditions include:

- `-eq`: True if the two numbers are equal.
- `-ne`: True if the two numbers are not equal.
- `-gt`: True if the first number is greater than the second number.
- `-lt`: True if the first number is less than the second number.
- `-ge`: True if the first number is greater than or equal to the second number.
- `-le`: True if the first number is less than or equal to the second number.
- `==`: True if the two strings are equal.
- `!=`: True if the two strings are not equal.

One very common use of `if` is to check if the last command executed successfully or not, using the special variable `$?`:

```bash
if [[ $? -eq 0 ]];
then
    echo "The last command executed successfully."
else
    echo "The last command failed."
fi
```

## Loops

Bash supports the `for` and `while` loops for iterating over a set of commands.

The difference between the two is that the `for` loop iterates over a list of items, while the `while` loop iterates as long as a certain condition is true.

The syntax for a `for` loop is as follows:

```bash
for variable in list;
do
    # commands to execute for each item in the list
done
```
The `list` can be a space-separated list of items, a range of numbers, or the output of a command.

```bash
for i in 1 2 3 4 5;
do
    echo "The value of i is: $i"
done
```
```
for i in {1..5};
do
    echo "The value of i is: $i"
done
```
We can also use the output of a command as the list:

```bash
for file in $(ls);
do
    echo "The file is: $file"
done
```

A common pattern in programming is to iterate over the element of an array or list, and modify them someway:

```bash
nums=(1 2 3 4 5)
squared_nums=()
for i in "${nums[@]}";
do
    squared_nums[i]=$((nums[i] * nums[i]))
done
echo "Squared numbers: ${squared_nums[@]}"
```
    
Differently from the `for` loop, the `while` loop iterates as long as a certain condition is true. Note that this means that if the condition is never false, the loop will run indefinitely, so it is important to make sure that the condition will eventually become false.
The syntax for a `while` loop is as follows:

```bash
while [[ condition ]];
do
    # commands to execute as long as the condition is true
done
```

Example of a `while` loop that counts from 1 to 5:

```bash
counter=1
while [[ $counter -le 5 ]];
do
    echo "Counter: $counter"
    counter=$((counter + 1))
done
```

Similar to the `while` loop, there is also the `until` loop which iterates as long as a certain condition is false:

```bash
until [[ condition ]];
do
    # commands to execute as long as the condition is false
done
```

`until` example that whaits until a file called `myfile.txt` exists:

```bash
until [[ -f myfile.txt ]];
do
    echo "Waiting for myfile.txt to be created..."
    sleep 1
done
echo "myfile.txt has been created!"
```


In both `while`/`until` and `for` loops it is possible to use two special statements to control the flow of the loop: 

- `break`: This statement is used to exit the loop immediately, regardless of the condition. It is often used to exit a  `while true` loop when a certain condition is met.

```bash
# wait until there is a idle node in the EPYC partition
while true;
do
    if [[ $(sinfo -p EPYC | grep idle | wc -l) -gt 0 ]];
    then
        echo "There is an idle node in the EPYC partition!"
        break
    fi
    echo "No idle nodes in the EPYC partition, waiting..."
    sleep 60
done
```

- `continue`: This statement is used to skip the rest of the commands in the current iteration of the loop and move on to the next iteration. It is often used to skip over certain iterations of a loop when a certain condition is met.

```bash
for i in {1..10};
do
    if [[ $((i % 2)) -eq 0 ]];
    then
        echo "Skipping even number: $i"
        continue
    fi
    echo "Processing odd number: $i"
done
```

## Functions

Bash also supports the definition of functions, which are reusable blocks of code that can be called multiple times within a script. The syntax for defining a function is as follows:

```bash
function function_name() {
    # commands to execute when the function is called
}
```
or alternatively:

```bash
function_name() {
    # commands to execute when the function is called
}
```

Function can also accept parameters, which can be accessed within the function using the special variables `$1`, `$2`, etc.

```bash
hello_world() {
    echo "Hello, World!"
}

function helper() {
    echo "This is a helper function that takes two parameters: $1 and $2"
}
```
To call a function, you simply need to use its name followed by any necessary parameters:

```bash
hello_world
helper "parameter1" "parameter2"
```

## Argument parsing

We have seen that it is possible to pass positional parameters to a Bash script and access them using the special variables `$1`, `$2`, and so on. 

However, this approach quickly becomes difficult to manage when a script needs many parameters, especially if some of them are optional.
A more structured solution is to use the `getopt` command. 
Unlike `getopts`, which only supports short options (e.g. `-o`), getopt allows parsing both short and long options (e.g. `-o` and `--option1`) in a consistent and flexible way.

The typical workflow when using getopt is:

- Define short and long options.
- Parse the arguments with getopt.
- Normalize them using eval set --.
- Process them with a while loop and a case statement.

The general structure looks like this:

```bash
PARSED=$(getopt -o shortopts -l longopts -- "$@") || exit 1
eval set -- "$PARSED"

while true; do
    case "$1" in
        -o|--option)
            # handle option1
            shift 2
            ;;
        -s|--setting)
            # handle option2
            shift 2
            ;;
        # ... other options ...
        --)
            shift
            break
            ;;
        *)
            exit 1
            ;;
    esac
done
```


Important Notes

- The colon `:` after an option (e.g. `o:`) means that the option requires an argument.
Long options that require arguments must also end with : (e.g. `option1:`).
- The separator `--` is used to indicate the end of options. Arguments after `--` are treated as positional parameters and can be accessed with `$1`, `$2`, etc. after the loop.
- Always include a help option to provide usage information for your script.


Example
Suppose we want to create a script that accepts:
-h or --help to display usage
-o or --option1 with a value
-p or --option2 with a value
Here is the complete implementation:

```bash
#!/usr/bin/env bash

usage() {
    echo "Usage: $0 -u USER [-a] [other parameters]"
    echo
    echo "Options:"
    echo "  -h, --help            Show this help message and exit"
    echo "  -u, --user USER       (Required) Set the user"
    echo "  -a, --admin           (Optional) Set user as admin"
    echo
    echo "Example:"
    echo "  $0 -u alice -a file1 file2"
}

# Parse options
PARSED=$(getopt -o hu:a -l help,user:,admin -- "$@") || {
    usage
    exit 1
}

# Normalize parameters
eval set -- "$PARSED"

# Default values
usr=""
grp=""
admin=false

# Process options
while true; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -u|--user)
            usr="$2"
            shift 2
            ;;
        -a|--admin)
            admin=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Enfored required parameters
if [[ -z "$usr" ]];
then
    echo "Error: --user is required"
    usage
    exit 1
fi
others=("$@")

# Output 
echo "User: $usr"
echo "Admin: $admin"
echo "Other parameters: ${others[*]}"
```


```
ipasia00@login01:~$ ./opt-demo.sh
Error: --user is required
Usage: ./opt-demo.sh -u USER [-a] [other parameters]

Options:
  -h, --help            Show this help message and exit
  -u, --user USER       (Required) Set the user
  -a, --admin           (Optional) Set user as admin

Example:
  ./opt-demo.sh -u alice -a file1 file2
ipasia00@login01:~$ ./opt-demo.sh -u isac
User: isac
Admin: false
Other parameters:
ipasia00@login01:~$ ./opt-demo.sh --user isac -a so long and thanks for all the fish
User: isac
Admin: true
Other parameters: so long thanks and for all the fish
ipasia00@login01:~$ ./opt-demo.sh This messages --user isac is written -a between other options
User: isac
Admin: true
Other parameters: This messages is written between other options
```

---
<br> 
Authors: Isac Pasianotto, Stefano Cozzini

