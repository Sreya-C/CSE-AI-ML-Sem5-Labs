#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>
void ErrorHadler(int error_code);

int main(int argc,char * argv[])
{
	int rank,size,fact,factsum,error_code;
	MPI_Init(&argc,&argv);
	MPI_Errhandler_set(MPI_COMM_WORLD,MPI_ERRORS_RETURN);
	error_code = MPI_Comm_rank(35,&rank);
	ErrorHadler(error_code);
	int num = rank + 1;
	MPI_Scan(&num,&fact,1,MPI_INT,MPI_PROD,MPI_COMM_WORLD);
	printf("Rank %d, Factorial = %d\n",num,fact);
	MPI_Reduce(&fact,&factsum,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		printf("Sum of factorials = %d\n",factsum);
	}
	MPI_Finalize();
}

void ErrorHadler(int error_code)
{
	if (error_code != MPI_SUCCESS)
	{
		char error_string[BUFSIZ];
		int length_of_error_string, error_class;
		MPI_Error_class(error_code, &error_class);
		MPI_Error_string(error_code, error_string, &length_of_error_string);
		fprintf(stderr, "%d -- %s\n", error_class, error_string);
		exit(0);
	}
}