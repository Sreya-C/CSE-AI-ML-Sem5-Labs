#include <mpi.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char * argv[])
{
	int rank,size,countnonvowel=0,chunk;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	char str[100],substr[50];
	int nonvowels[size],totalcount = 0;
	if(rank==0)
	{
		printf("Enter a string: ");
		scanf("%s",str);
		printf("%zu\n",strlen(str));
		chunk = strlen(str)/size;
	}
	MPI_Bcast(&chunk,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(str,chunk,MPI_CHAR,substr,chunk,MPI_CHAR,0,MPI_COMM_WORLD);
	substr[chunk] = '\0';
	for(int i=0;i<chunk;i++)
	{
		if(substr[i] != 'a' && substr[i] != 'e' && substr[i] != 'i' && substr[i] != 'o' && substr[i] != 'u' && substr[i] != 'A' && substr[i] != 'E' && substr[i] != 'I' && substr[i] != 'O' && substr[i] != 'U')
		{
			countnonvowel += 1;
		}
	}
	MPI_Gather(&countnonvowel,1,MPI_INT,nonvowels,1,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		for(int i=0;i<size;i++)
		{
			printf("%d",nonvowels[i]);
		}	
		for(int i=0;i<size;i++)
		{
			printf("Number of non vowels in rank %d = %d\n",i,nonvowels[i]);
			totalcount += nonvowels[i];
		}
		printf("Total Number of non vowels: %d\n",totalcount);
	}
	MPI_Finalize();
}