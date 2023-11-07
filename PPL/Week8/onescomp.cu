#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <string.h>
#include <stdio.h>

// Define matrix dimensions (M and N)
#define M 4
#define N 4

__global__ void onesComplement(int *A, int *B, int rows, int cols)
{
    int rid = blockIdx.y * blockDim.y + threadIdx.y;
    int cid = blockIdx.x * blockDim.x + threadIdx.x;

    if (rid >= 0 && rid < rows && cid >= 0 && cid < cols)
    {
        if (rid > 0 && rid < rows - 1 && cid > 0 && cid < cols - 1)
        {
            // Calculate the index for the current element
            int index = rid * cols + cid;
            // Calculate the 1's complement of the element and store it in B
            int number = A[index];
            int rev = 0;
            for (int i = 0; number > 0; i++)
            {
                rev *= 10;
                rev += 1 - number % 2;
                number = number / 2;
            }
            B[index] = rev;
        }
        else
        {
            // Copy border elements as-is
            B[rid * cols + cid] = A[rid * cols + cid];
        }
    }
}

int main()
{
    int A[M][N];
    int B[M][N];

    for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            A[i][j] = i * N + j;
        }
    }

    int *d_A, *d_B; // Device pointers for matrices A and B

    cudaMalloc((void **)&d_A, M * N * sizeof(int));
    cudaMalloc((void **)&d_B, M * N * sizeof(int));
    cudaMemcpy(d_A, A, M * N * sizeof(int), cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(16, 16);
    dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x, (M + threadsPerBlock.y - 1) / threadsPerBlock.y);

    onesComplement<<<numBlocks, threadsPerBlock>>>(d_A, d_B, M, N);

    cudaMemcpy(B, d_B, M * N * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Matrix A:\n");
    for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            printf("%d ", A[i][j]);
        }
        printf("\n");
    }

    printf("Matrix B (1's complement of non-border elements in binary):\n");
    for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            printf("%d ", B[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);

    return 0;
}