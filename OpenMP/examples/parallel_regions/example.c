
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

int main(void)
{
  int sum = 0;
 #pragma omp parallel
  {
    int myid = omp_get_thread_num();
    sum += myid;
  }
  printf("sum is %d\n", sum);
  return 0;
}
