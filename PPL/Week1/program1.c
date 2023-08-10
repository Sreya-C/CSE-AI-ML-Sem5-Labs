#include <mpi.h>
#include <stdio.h>

int main(int argc, char * argv[])
{
	int rank,size,a=10;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	printf("My rank is %d in total %d processes", rank, size);	
	MPI_Finalize();
	return 0;
}

