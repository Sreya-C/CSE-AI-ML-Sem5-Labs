#include <mpi.h>
#include <stdio.h>
#define BUFSIZE 512


int main(int argc, char * argv[])
{
	int rank,size,n,a[20],buf[50],bufsize;
	bufsize = BUFSIZE;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Status status;
	MPI_Buffer_attach(buf,bufsize);
	if (rank==0)
	{
		printf("Enter elements to send: ");
		for(int i=0;i<size;i++)
		{
			scanf("%d",a + i);
		}
		for(int i=0;i<size;i++)
		{
			MPI_Bsend(a+i,1,MPI_INT,i,i,MPI_COMM_WORLD);
		}
	}
	MPI_Recv(&n,1,MPI_INT,0,rank,MPI_COMM_WORLD,&status);
	if (rank%2==0)
	{
		printf("Rank %d received %d. Square is %d\n",rank,n,n*n);
	}
	if (rank%2!=0)
	{
		printf("Rank %d received %d. Cube is %d\n",rank,n,n*n*n);
	}
	MPI_Buffer_detach(buf,&bufsize);
	MPI_Finalize();

}