//
// Created by enric on 15/04/26.
//
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main() {

    #pragma omp parallel
    {
        int thread_num = omp_get_thread_num();
        printf("Thread %d\n", thread_num);
    }

    return 0;
}
