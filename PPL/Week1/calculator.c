/*Write a program in MPI to simulate simple calculator. Perform each operation using different process in parallel.*/

#include <stdio.h>
#include <mpi.h>

int main(int argc, char * argv[])
{
	int rank,num1 = 39,num2 = 19;
	double result;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	switch(rank)
	{
		case 0: result = num1 + num2;
			printf("Rank: %d, %d + %d\n",rank, num1,num2);
			printf("%d + %d = %f\n",num1,num2,result); 
			break;
		case 1: result = num1 - num2;
			printf("Rank: %d, %d - %d\n",rank, num1,num2);
			printf("%d - %d = %f\n",num1,num2,result); 
			break;
		case 2: result = num1 * num2;
			printf("Rank: %d, %d * %d\n",rank, num1,num2);
			printf("%d * %d = %f\n",num1,num2,result); 
			break;
		case 3: result = (double) num1 / num2;
			printf("Rank: %d, %d / %d\n",rank, num1,num2);
			printf("%d / %d = %f\n",num1,num2,result); 
	}
	MPI_Finalize();
}

