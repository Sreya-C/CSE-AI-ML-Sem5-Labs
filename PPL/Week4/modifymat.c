#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    int rank, size, a[4][4], b[4], total[4];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        printf("Enter the input matrix:\n");
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                scanf("%d", &a[i][j]);

        printf("Input Matrix:\n");
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
                printf("%d\t", a[i][j]);
                    printf("\n");
        }
    }
    MPI_Scatter(a, 4, MPI_INT, b, 4, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scan(b, total, 4, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    MPI_Gather(total, 4, MPI_INT, a, 4, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank == 0)
    {
        fprintf(stdout, "Column sum are:\n");

        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                fprintf(stdout, "%d\t", a[i][j]);

            }
            fprintf(stdout, "\n");

        }
    }
    MPI_Finalize();
}
