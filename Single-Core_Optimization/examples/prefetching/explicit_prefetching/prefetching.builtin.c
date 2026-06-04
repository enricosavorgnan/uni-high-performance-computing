
/* ────────────────────────────────────────────────────────────────────────── *
 │                                                                            │
 │ This file is part of the exercises for the Lectures on                     │
 │   "Foundations of High Performance Computing"                              │
 │ given at                                                                   │
 │   Master in HPC and                                                        │
 │   Master in Data Science and Scientific Computing                          │
 │ @ SISSA, ICTP and University of Trieste                                    │
 │                                                                            │
 │ contact: luca.tornatore@inaf.it                                            │
 │                                                                            │
 │     This is free software; you can redistribute it and/or modify           │
 │     it under the terms of the GNU General Public License as published by   │
 │     the Free Software Foundation; either version 3 of the License, or      │
 │     (at your option) any later version.                                    │
 │     This code is distributed in the hope that it will be useful,           │
 │     but WITHOUT ANY WARRANTY; without even the implied warranty of         │
 │     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          │
 │     GNU General Public License for more details.                           │
 │                                                                            │
 │     You should have received a copy of the GNU General Public License      │
 │     along with this program.  If not, see <http://www.gnu.org/licenses/>   │
 │                                                                            │
 * ────────────────────────────────────────────────────────────────────────── */



#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>


#define CPU_TIME ({struct timespec ts; clock_gettime( CLOCK_PROCESS_CPUTIME_ID, &ts ),\
					 (double)ts.tv_sec +		\
					 (double)ts.tv_nsec * 1e-9;})

#define TEMPORAL_HINT 0

int mybsearch(int *data, int N, int Key)

/*
  TWO PREFETCHING SCHEMES:
  
  -DENABLE_PREFETCHING  :  prefetching of the TWO new mid elements
  -DENABLE_PREFETCHING2 :  prefetching of the TWO new mid elements + FOUR next new ones
  
  [·········v·········X··········v········0···········v·········X········v·······]
            |         |          |     current        |         |        /
            |         \          |                    |        /        /
            |         \_____     |                    |   -----        /
            |               \    |                    :  |            /
            |                ----:------------> new mid elems        /
            \________            :                    :             /
                     \           \                    /            /
                      ----------------> next 4 new mids <----------

*/
 {
   int register low = 0;
   int register high = N;
   int register mid;

   mid = (low + high) / 2;
   while(low <= high) {     

     
    #if defined(PREFETCHING_ENABLED)
     __builtin_prefetch (&data[(low + mid - 1)>>1], 0, TEMPORAL_HINT);
     __builtin_prefetch (&data[(mid + 1 + high)>>1], 0, TEMPORAL_HINT);
    #elif defined(PREFETCHING_ENABLED2)
     int low_mid  = (low + mid - 1)>>1;
     int high_mid = (mid + 1 + high)>>1;

     // left branch
     __builtin_prefetch ( &data[low_mid], 0, TEMPORAL_HINT );
     __builtin_prefetch ( &data[(low+low_mid-1)>>1], 0, TEMPORAL_HINT );
     __builtin_prefetch ( &data[(low_mid+1+mid)>>1], 0, TEMPORAL_HINT );
     // right branch
     __builtin_prefetch ( &data[high_mid], 0, TEMPORAL_HINT);
     __builtin_prefetch ( &data[(mid+high_mid-1)>>1], 0, TEMPORAL_HINT );
     __builtin_prefetch ( &data[(high_mid+1+high)>>1], 0, TEMPORAL_HINT );

    #endif


     int flag = (data[mid] > Key) - (data[mid] < Key);

     switch ( flag )
       {
       case -1: low = mid+1; break;
       case 0: return mid; break;
       case 1: high = mid-1; break;
       }

     
     mid = (low + high) / 2;
   }

   return -1;
 }

#define N_DEFAULT  (1024*1024*91)
#define N_search_DEFAULT (N_DEFAULT / 15)

int main(int argc, char **argv)
{
  int N, Nsearch, i;
  int *data, *search;

  if(argc > 1)
    N = atoi( *(argv+1) );
  else
    N = N_DEFAULT;

  if(argc > 2)
    Nsearch = atoi ( *(argv + 2) );
  else
    Nsearch = N_search_DEFAULT;

#ifdef PREFETCHING_ENABLED
  printf("performing %d lookups on %d data with prefetching enabled..\n", Nsearch, N);
#else
  printf("performing %d lookups on %d data..\n", Nsearch, N);
#endif

  printf("set-up data.."); fflush(stdout);
  data = malloc(N * sizeof(int));
  for (i = 0; i < N; i++)
    data[i] = i;

  printf(" set-up lookups.. "); fflush(stdout);  
  search = malloc(Nsearch * sizeof(int));
  srand(time(NULL));
  for (i = 0; i < Nsearch; i++)
    search[i] = rand() % N;

  int found = 0;
  double tstart, tstop;

  printf("\nstart search loop.. "); fflush(stdout);
  tstart = CPU_TIME;
  for (i = 0; i < Nsearch; i++)
    if( mybsearch(data, N, search[i]) >= 0)
      found++;
  tstop = CPU_TIME;

  printf("\n%d data found\n"
	 "time elapsed: %g\n",
	 found, tstop - tstart);

  free(data);
  free(search);

  return 0;
 }
