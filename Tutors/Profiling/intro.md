---
icon: material/compass
---

# Profiling, why it matters?

!!! abstract "What is profiling?"
    Profiling is the process of assessing the behavior of a program, decomposing it into its components and measuring the time spent in each of them. This is a crucial step in the optimization process, as it allows us to identify the bottlenecks in our code and focus our efforts on optimizing those parts.


Even if concemptually simile to benchmarking, profiling is a different process, since it focus is not evaluating the behavior of the code under different conditions (e.g., different input sizes, different number of processes, etc.) but rather to understand what causes the performance of the code to be what it is, and most importantly where extra effort should be put to.

## How to profile a code?

There are two approaches to profile a code:

- ***Instrumentation***: add some code to the program to measure the time spent in each function or block of code. 
- ***Sampling***: Rely on an external tool, called ***profiler*** to perdiodically capture the state of the program and then analyze the results to understand where the program is spending most of its time.



## Instrumentation Profiling

Instrumentation profiling is a technique that involves adding code to the program to measure the time spent in each function or block of code. This can be done manually by adding timers to the code, or by using a profiling library that provides an API for instrumentation.

***Advantages***:

- Can provide very detailed information on exactly what you want to investigate.
- Can be used to measure the time spent in specific functions or blocks of code, which can be useful for identifying bottlenecks and optimizing specific parts of the code.

***Disadvantages***:

- Can be intrusive, as it requires modifying the code. This can be time-consuming and may introduce bugs or change the behavior of the program.
- If not done carefully, it can introduce overhead, which can affect both affect the performance of the program lead to inaccurate results.
- Can be difficult to trace the flow of the program, especially in highly parallel code with many processes.
