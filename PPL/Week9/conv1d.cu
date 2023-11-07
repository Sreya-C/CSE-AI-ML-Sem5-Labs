#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void convolution(int *N, int *M, int *P, int width, int mask_width)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    int Pvalue = 0;
    int N_start_point = tid - (mask_width / 2);
    for (int j = 0; j < mask_width; j++)
    {
        if (N_start_point + j >= 0 && N_start_point + j < width)
        {
            Pvalue += N[N_start_point + j] * M[j];
        }
    }
    P[tid] = Pvalue;
}

int main(void)
{

    int width, mask_width;

    printf("Enter width of array: ");
    scanf("%d", &width);
    printf("Enter width of mask: ");
    scanf("%d", &mask_width);
    int *N = (int *)malloc(width * sizeof(int));
    int *M = (int *)malloc(mask_width * sizeof(int));
    int *P = (int *)malloc(width * sizeof(int));
    printf("Enter values of array: ");
    for (int i = 0; i < width; i++)
    {
        scanf("%d", &N[i]);
    }

    printf("Enter values of mask: ");
    for (int i = 0; i < mask_width; i++)
    {
        scanf("%d", &M[i]);
    }
    int *d_N, *d_M, *d_P;
    cudaMalloc((void **)&d_N, width * sizeof(int));
    cudaMalloc((void **)&d_M, mask_width * sizeof(int));
    cudaMalloc((void **)&d_P, width * sizeof(int));
    cudaMemcpy(d_N, N, width * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_M, M, mask_width * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_P, P, width * sizeof(int), cudaMemcpyHostToDevice);
    int block_size = 256;
    int grid_size = (width + block_size - 1) / block_size;
    convolution<<<grid_size, block_size>>>(d_N, d_M,d_P, width, mask_width);

    cudaMemcpy(P, d_P, width * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < width; i++)
    {
        printf("%d ", P[i]);
    }
    printf("\n");
    cudaFree(d_N);
    cudaFree(d_M);
    cudaFree(d_P);

    return 0;
}