/*Write a simple MPI program to find out pow (x, rank) for all the processes where ‘x’ is the integer constant and ‘rank’ is the rank of the process.*/

#include <stdio.h>
#include <mpi.h>
#include <math.h>

int main(int argc, char * argv[])
{
	int rank,degree=4;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	printf("pow (%d, rank %d) = %f\n",degree,rank,pow(degree,rank));
	MPI_Finalize();
}

