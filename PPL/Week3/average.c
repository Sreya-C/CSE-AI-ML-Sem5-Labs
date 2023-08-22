#include <mpi.h>
#include <stdio.h>

double average(int a[],int n)
{
	int sum;
	for(int i=n-1;i>=0;i--)
	{
		sum += a[i];
	}
	double avg = (double)sum/n;
	return avg;
}

int main(int argc, char * argv[])
{
	int rank,size,m,arr[100];
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	double arravg[size],avg,sum=0;
	if(rank==0)
	{	
		printf("Enter no. of values in each process: ");
		scanf("%d",&m);
		printf("Enter %d values: ",size*m);
		for(int i=0;i<size*m;i++)
		{
			scanf("%d",&arr[i]);
		}
	}
	MPI_Bcast(&m,1,MPI_INT,0,MPI_COMM_WORLD);
	int	a[m];
	MPI_Scatter(arr,m,MPI_INT,a,m,MPI_INT,0,MPI_COMM_WORLD);
	avg = average(a,m);
	printf("Average in rank %d = %f\n",rank,avg);
	MPI_Gather(&avg,1,MPI_DOUBLE,arravg,1,MPI_DOUBLE,0,MPI_COMM_WORLD);
	if(rank==0)
	{	
		for(int i=0;i<size;i++)
		{
			sum += arravg[i];
		}
		printf("Average of given values = %f\n",(double)sum/size);
	}
	MPI_Finalize();
}