

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


#if defined(__STDC__)
#  if (__STDC_VERSION__ >= 201112L)    // c11
#    define _XOPEN_SOURCE 700
#  elif (__STDC_VERSION__ >= 199901L)  // c99
#    define _XOPEN_SOURCE 600
#  else
#    define _XOPEN_SOURCE 500          // c90
#  endif
#endif

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#if _XOPEN_SOURCE >= 600
#  include <strings.h>
#endif
#include <sys/resource.h>
#include <sys/times.h>
#include <time.h>
#include <math.h>

#define STRIDED_WRITE 0
#define CONTIGUOUS_WRITE  1

#define NRUNS    5               // NOTE: AT LEAST THIS MUST BE AT LEAST 2
#if (NRUNS < 2)
#error "NRUNS must be larger than 1"
#endif


#define CPU_TIME ({struct  timespec ts; clock_gettime( CLOCK_PROCESS_CPUTIME_ID, &ts ),	\
                                          (double)ts.tv_sec +           \
                                          (double)ts.tv_nsec * 1e-9;})


double **allocate_matrix( int N )
{
  double **matrix = (double**)calloc( N, sizeof(double*) );
  if ( matrix == NULL )
    return NULL;
  for ( int row = 0; row < N; row++ ) {
    matrix[row]  = (double*)calloc( N, sizeof(double) );
    if( matrix[row] == NULL )
      return NULL; }
  return matrix;
}


void transpose_strided_write( const double * restrict * restrict matrix, double * restrict * restrict tmatrix, int N )
{
  for (int r = 0; r < N; r++)
    for ( int c = 0; c < N; c++ )
      tmatrix[c][r] = matrix[r][c];
  return;
}


void transpose_contiguous_write( const double * restrict * restrict matrix, double * restrict * restrict tmatrix, int N )
{
  for (int r = 0; r < N; r++)
    for ( int c = 0; c < N; c++ )
      tmatrix[r][c] = matrix[c][r];	
  return;
}

int main(int argc, char **argv)
{
  int     mode          = (argc > 1 ? atoi(*(argv+1)) : STRIDED_WRITE );
  int     N             = (argc > 2 ? atoi(*(argv+2)) : 10000 );  

  double * restrict * restrict matrix  = allocate_matrix( N );
  double * restrict * restrict tmatrix = allocate_matrix( N );

  if ( (matrix == NULL) ||
       (tmatrix == NULL) )
    {
      printf("allocation has not succeeded. Try a smaller N\n");
      exit(1);
    }

  printf("tranposing a %d x %d matrix with %s\n", N, N,
	 ( mode == STRIDED_WRITE ? "strided write" : "contiguous write") );
  
  /* load the data in the highest cache level that fits */
  for (int i = 0, r = 0; r < N; r++)
    for ( int c = 0; c < N; c++, i++ ) {
      matrix[r][c]  = (double)i;
      tmatrix[r][c] = 0; }
  
  double timing, timing_max;
	 
  if ( mode == STRIDED_WRITE ) {
    // warmup
    transpose_strided_write( (const double * restrict * restrict)matrix, tmatrix, N );
    
    for ( int i = 0; i < NRUNS; i++ ) {
      double this_timing = CPU_TIME;	
      transpose_strided_write( (const double * restrict * restrict)matrix, tmatrix, N ); 
      this_timing = CPU_TIME - this_timing;
      if ( i == 0) timing_max = this_timing;
      else timing_max = ( timing_max < this_timing ? this_timing : timing_max );
      timing += this_timing;
    }
  }    
  else {  // STRIDED_READ
    // warmup
    transpose_contiguous_write( (const double * restrict * restrict)matrix, tmatrix, N );

    for ( int i = 0; i < NRUNS; i++ ) {
      double this_timing = CPU_TIME;	
      transpose_contiguous_write( (const double * restrict * restrict)matrix, tmatrix, N );
      this_timing = CPU_TIME - this_timing;
      if ( i == 0) timing_max = this_timing;
      else timing_max = ( timing_max < this_timing ? this_timing : timing_max );
      timing += this_timing;
    }
  }
    
  timing = (timing - timing_max) / (NRUNS-1);
  printf("timing (avg among %d shots): %g bw: %g\n", NRUNS-1,
	 timing, N*N*sizeof(double)/timing/(1024.0*1024.0) );
  
  
  FILE *out = fopen("donotoptimizeout.dat", "w");
  for ( int r = 0; r < N; r++ )
    fwrite( tmatrix[r], N,  sizeof(double), out);
  fclose(out);
  system("rm -f donotoptimizeout.dat");


  for ( int r = 0; r < N; r++ )
    {
      free( (void*)matrix[r] );
      free( (void*)tmatrix[r] );
    }
  free( (void*)matrix );
  free( (void*)tmatrix );

  return 0;
}
