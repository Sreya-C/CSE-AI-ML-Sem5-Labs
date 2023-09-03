#include <stdio.h>
#include <mpi.h>

int main(int argc, char * argv[])
{
	int rank,size,n,a[20];
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Status status;
	if (rank==0)
	{
		printf("Enter elements to send: ");
		for(int i=1;i<size;i++)
		{
			scanf("%d",a + i);
		}
		for(int i=1;i<size;i++)
		{
			MPI_Send(a+i,1,MPI_INT,i,i,MPI_COMM_WORLD);
		}

	}
	else
	{
		MPI_Recv(&n,1,MPI_INT,0,rank,MPI_COMM_WORLD,&status);
		printf("Rank %d received %d\n",rank,n);
	}
	MPI_Finalize();
}