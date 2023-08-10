/*Write a program in MPI where even ranked process prints “Hello” and odd ranked process
prints “World”*/

#include <stdio.h>
#include <mpi.h>

int main(int argc, char * argv[])
{
	int rank,degree=4;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if (rank%2!=0) printf("Rank %d\tWorld\n",rank);
	else printf("Rank %d\tHello\n",rank);
	MPI_Finalize();
}

