//
// Created by enric on 15/04/26.
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int sum = 0;
    int num_threads = 0;

#pragma omp parallel
    {
        num_threads = omp_get_num_threads();
        int num = omp_get_thread_num();

#pragma omp critical
        sum += num;
    }

    printf("Sum: %d\nExpected: %d\n", sum, num_threads*(num_threads-1)/2);
    return 0;
}
