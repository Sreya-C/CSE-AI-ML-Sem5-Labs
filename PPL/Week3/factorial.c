#include <mpi.h>
#include <stdio.h>

int factorial(int n)
{
	int fact = 1;
	for(int i=n;i>1;i--)
	{
		fact *= i;
	}
	return fact;
}

int main(int argc, char * argv[])
{
	int rank,size,sum=0,num,fact;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	int a[size],factsum[size];
	if(rank==0)
	{	
		printf("Enter %d values: ",size);
		for(int i=0;i<size;i++)
		{
			scanf("%d",&a[i]);
		}
	}
	MPI_Scatter(a,1,MPI_INT,&num,1,MPI_INT,0,MPI_COMM_WORLD);
	fact = factorial(num);
	printf("Rank %d, Factorial = %d\n",rank,fact);
	MPI_Gather(&fact,1,MPI_INT,factsum,1,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		for(int i=0;i<size;i++)
		{
			sum += factsum[i];
		}
		printf("Sum of Factorials = %d\n",sum);
	}
	MPI_Finalize();
}