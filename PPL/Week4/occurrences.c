#include <stdio.h>
#include <mpi.h>

 

int main(int argc,char * argv[])
{
    int rank,size,n,mat[3][3],row[3],rowoccur=0,total;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);
    if(rank==0)
    {
        printf("Enter the 9 matrix elements: ");
        for(int i=0;i<3;i++)
        {
            for(int j=0;j<3;j++)
            {
                scanf("%d",&mat[i][j]);
            }
        }
        printf("Enter element to search: ");
        scanf("%d",&n);
    }
    MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(mat, 3, MPI_INT, row, 3, MPI_INT, 0, MPI_COMM_WORLD);
    for(int i=0;i<3;i++)
    {
        if(row[i] == n)
        {
            rowoccur += 1;
        }
    }
    MPI_Reduce(&rowoccur,&total,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
    if(rank==0)
    {
        printf("Number of %d occurrences = %d\n",n,total);
    }
}