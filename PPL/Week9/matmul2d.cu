#include <stdio.h>  
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define N 3

__global__ void matrixMul(int *a, int *b, int *c, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int sum = 0;
    if (row < n && col < n) {
        for (int i = 0; i < n; i++) {
            sum += a[row * n + i] * b[i * n + col];
        }
        c[row * n + col] = sum;
    }
}

int main(void) {
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = N * N * sizeof(int);

    // Allocate space for device copies of a, b, c
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);

    // Setup input values
    a = (int *)malloc(size);
    b = (int *)malloc(size);
    c = (int *)malloc(size);

    for (int i = 0; i < N * N; i++) {
        a[i] = i;
        b[i] = i+1;
    }

    // Copy inputs to device
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    // Launch add() kernel on GPU
    dim3 dimGrid(1, 1, 1);
    dim3 dimBlock(N, N, 1);
    matrixMul<<<dimGrid, dimBlock>>>(d_a, d_b, d_c, N);

    // Copy result back to host
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // Print result
    printf("Matrix A:\n");
    for (int i = 0; i < N * N; i++) {
        printf("%d ", a[i]);
        if ((i + 1) % N == 0) {
            printf("\n");
        }
    }
    printf("\n");

    printf("Matrix B:\n");
    for (int i = 0; i < N * N; i++) {
        printf("%d ", b[i]);
        if ((i + 1) % N == 0) {
            printf("\n");
        }
    }
    printf("\n");

    printf("Matrix C:\n");
    for (int i = 0; i < N * N; i++) {
        printf("%d ", c[i]);
        if ((i + 1) % N == 0) {
            printf("\n");
        }
    }
    printf("\n");

    // Cleanup
    free(a);
    free(b);
    free(c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}