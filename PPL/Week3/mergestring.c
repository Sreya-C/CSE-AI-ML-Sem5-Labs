#include <mpi.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char * argv[])
{
	int rank,size,chunk;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	char str1[100],str2[100],merge[200];
	if(rank==0)
	{
		printf("Enter 1st string: ");
		scanf("%s",str1);
		printf("Enter 2nd string: ");
		scanf("%s",str2);
		chunk = strlen(str1)/size;
	}
	MPI_Bcast(&chunk,1,MPI_INT,0,MPI_COMM_WORLD);
	char c1[chunk],c2[chunk];
	MPI_Scatter(str1,chunk,MPI_CHAR,c1,chunk,MPI_CHAR,0,MPI_COMM_WORLD);
	MPI_Scatter(str2,chunk,MPI_CHAR,c2,chunk,MPI_CHAR,0,MPI_COMM_WORLD);
	char concat[chunk*2];
	int t = 0;
	for (t = 0; t <= 2 * chunk; t += 2) 
	{
		concat[t] = c1[t/2];
		concat[t+1] = c2[t/2];
	}
	concat[2*chunk] = '\0';
	printf("Rank %d, Intermediate String: %s\n",rank,concat);
	MPI_Gather(concat, 2*chunk, MPI_CHAR, merge, 2*chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
	if (rank == 0) 
	{
		merge[chunk*size*2] = '\0';
		printf("Concatted: %s\n",merge);
	}
	MPI_Finalize();
}