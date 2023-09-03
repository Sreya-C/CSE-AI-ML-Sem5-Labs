#include <stdio.h>
#include <mpi.h>

int main(int argc, char * argv[])
{
	int rank,size,n;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Status status;
	if (rank==0)
	{
		printf("Enter element to send: ");
		scanf("%d",&n);
		MPI_Send(&n,1,MPI_INT,1,1,MPI_COMM_WORLD);
		MPI_Recv(&n,1,MPI_INT,size-1,size,MPI_COMM_WORLD,&status);
		printf("Final value in Rank %d = %d",rank,n);
	}
	else if (rank==size-1)
	{
		MPI_Recv(&n,1,MPI_INT,rank-1,rank,MPI_COMM_WORLD,&status);
		printf("Rank %d receieved %d. Sending %d\n",rank,n,n+1);
		n++;
		MPI_Send(&n,1,MPI_INT,0,rank+1,MPI_COMM_WORLD);
	}
	else
	{
		MPI_Recv(&n,1,MPI_INT,rank-1,rank,MPI_COMM_WORLD,&status);
		printf("Rank %d receieved %d. Sending %d\n",rank,n,n+1);
		n++;
		MPI_Send(&n,1,MPI_INT,rank+1,rank+1,MPI_COMM_WORLD);
	}
	MPI_Finalize();
}