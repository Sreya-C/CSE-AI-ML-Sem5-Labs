/*Write a program in MPI where even ranked process prints factorial of the rank and odd ranked process prints ranks Fibonacci number.*/

#include <stdio.h>
#include <mpi.h>

int fact(int num)
{
	int result=1;
	for(int i=1;i<=num;i++)
	{
		result = result*i;
	}
	return result;
}

int fib(int num)
{
	int result;
	if (num == 1 || num == 2) return num-1;
	int first = 0, second = 1;
	for(int i=2;i<num;i++)
	{
		result = first + second;
		first = second;
		second = result;
	}
	return result;
}

int main(int argc, char * argv[])
{
	int rank;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if (rank%2==0)
	{
		int factorial;
		factorial = fact(rank);
		printf("Rank %d has Factorial = %d \n",rank,factorial);
	}
	else
	{
		int fibonacci;
		fibonacci = fib(rank);
		printf("Rank %d's Fibonacci number is %d\n",rank,fibonacci);
	}	
	MPI_Finalize();
}
