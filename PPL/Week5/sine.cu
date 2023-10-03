#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#define N 15

__global__ void findsin(float * a,float * output)
{
    int tid = blockDim.x*blockIdx.x + threadIdx.x;

    if(tid<N){
        output[tid] = sin(a[tid]);
    }
}

int main()
{
  float *h_a = (float *)malloc(N * sizeof(float));
  float *output = (float *)malloc(N * sizeof(float));
  for (int i = 0; i < N; i++) {
    h_a[i] = i*0.3;
  }

  float *d_a, *d_output;
  cudaMalloc(&d_a, N * sizeof(float));
  cudaMalloc(&d_output, N * sizeof(float));
  cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);

  findsin<<<1, N>>>(d_a,d_output);
  cudaMemcpy(output, d_output, N * sizeof(float), cudaMemcpyDeviceToHost);
  printf("Using N blocks\n");
  for (int i = 0; i < N; i++) {
    printf("%f\n", output[i]);
  }

}