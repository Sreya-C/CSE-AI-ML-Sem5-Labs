#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 5

__global__ void vecAdd1(float *a, float *b, float *c) {
  int id = threadIdx.x;
  if (id < N) {
    c[id] = a[id] + b[id];
  }
}
__global__ void vecAdd2(float *a, float *b, float *c) {
  int id = blockIdx.x;
  if (id < N) {
    c[id] = a[id] + b[id];
  }
}

int main() {
  float *h_a = (float *)malloc(N * sizeof(float));
  float *h_b = (float *)malloc(N * sizeof(float));
  float *h_c = (float *)malloc(N * sizeof(float));
  for (int i = 0; i < N; i++) {
    h_a[i] = i;
    h_b[i] = i+3;
  }

  float *d_a, *d_b, *d_c;
  cudaMalloc(&d_a, N * sizeof(float));
  cudaMalloc(&d_b, N * sizeof(float));
  cudaMalloc(&d_c, N * sizeof(float));
  cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, N * sizeof(float), cudaMemcpyHostToDevice);

  vecAdd1<<<1, N>>>(d_a, d_b, d_c);
  cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);
  printf("Using N blocks\n");
  for (int i = 0; i < N; i++) {
    printf("%f\n", h_c[i]);
  }

  vecAdd2<<<N, 1>>>(d_a, d_b, d_c);
  cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);
  printf("Using N threads\n");
  for (int i = 0; i < N; i++) {
    printf("%f\n", h_c[i]);
  }

  free(h_a);
  free(h_b);
  free(h_c);
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
  return 0;
}
