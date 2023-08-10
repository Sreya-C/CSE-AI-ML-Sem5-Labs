/*Write a program in MPI to toggle the character of a given string indexed by the rank of the process. Hint: Suppose the string is HELLO and there are 5 processes, then process 0 toggle ‘H’ to ‘h’, process 1 toggle ‘E’ to ‘e’ and so on.*/

#include <stdio.h>
#include <mpi.h>

int main(int argc,char * argv[])
{
	int rank;
	char array[] = "HELLO world";
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(array[rank]>=65 && array[rank]<=90)
         array[rank]+=32;
        else if(array[rank]>=97 && array[rank]<=122)
         array[rank]-=32;
	printf("Modified string for Rank %d: %s\n",rank,array);
	MPI_Finalize();
}
