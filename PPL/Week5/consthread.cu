#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <math.h>

#define N 10

__global__ void vecAdd(float *a, float *b, float *c) {
  int tid = threadIdx.x + blockIdx.x*blockDim.x;
  if (tid < N) {
    printf("%d,%d,%d,%d\n",threadIdx.x,blockDim.x,blockIdx.x,gridDim.x);
    c[tid] = a[tid] + b[tid];
  }
}

int main() {
  float *h_a = (float *)malloc(N * sizeof(float));
  float *h_b = (float *)malloc(N * sizeof(float));
  float *h_c = (float *)malloc(N * sizeof(float));
  for (int i = 0; i < N; i++) {
    h_a[i] = i;
    h_b[i] = 3*i;
  }

  float *d_a, *d_b, *d_c;
  cudaMalloc(&d_a, N * sizeof(float));
  cudaMalloc(&d_b, N * sizeof(float));
  cudaMalloc(&d_c, N * sizeof(float));
  cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, N * sizeof(float), cudaMemcpyHostToDevice);

  int numblocks = ceil(N/256)+1;
  vecAdd<<<numblocks,256>>>(d_a, d_b, d_c);
  cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);
  for (int i = 0; i < N; i++) {
    printf("%f\t", h_c[i]);
  }

  free(h_a);
  free(h_b);
  free(h_c);
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
  return 0;
}
