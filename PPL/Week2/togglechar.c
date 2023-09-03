#include <stdio.h>
#include <mpi.h>
#include <string.h>

int main(int argc, char * argv[])
{
	int rank,size,n;
	char str[20],newstr[20];
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Status status;
	if (rank==0)
	{
		printf("Enter a string to toggle: ");
		scanf("%s",str);
		n = strlen(str);
		MPI_Send(&n,1,MPI_INT,1,1,MPI_COMM_WORLD);
		MPI_Ssend(str,n,MPI_CHAR,1,2,MPI_COMM_WORLD);
		MPI_Recv(newstr,n,MPI_CHAR,1,3,MPI_COMM_WORLD,&status);
		newstr[n] = '\0';
		fprintf(stdout,"Rank %d, Modified string: %s\n",rank,newstr);
		fflush(stdout);
	}
	else
	{ 
		MPI_Recv(&n,1,MPI_INT,0,1,MPI_COMM_WORLD,&status);
		MPI_Recv(str,n,MPI_CHAR,0,2,MPI_COMM_WORLD,&status);
		str[n] = '\0';
		fprintf(stdout,"Rank %d,Received string %s\n",rank,str);
		fflush(stdout);
		for(int i=0;i<n;i++)
		{
			if(str[i]>=65 && str[i]<=90)
	        	str[i]+=32;
	        else if(str[i]>=97 && str[i]<=122)
	        	str[i]-=32;
		}
		MPI_Ssend(str,n,MPI_CHAR,0,3,MPI_COMM_WORLD);
	}
	MPI_Finalize();
}