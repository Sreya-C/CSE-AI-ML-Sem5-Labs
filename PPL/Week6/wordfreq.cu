#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include<string.h>

#define N 1024
__global__ void wordcount(char *A,char* B,int n, unsigned int *d_count){
    int i = threadIdx.x;
      for(int j=0; j<n; j++){
        if(A[i+j] != B[j]) 
            return;}
    atomicAdd(d_count, 1);
}

int main() 
{
    char A[N],B[N];
    char *d_A,*d_B;

    unsigned int *count,*result,*d_count;
    count=(unsigned int *) malloc(1 * sizeof(unsigned int));
    result=(unsigned int *) malloc(1 * sizeof(unsigned int));

    printf("Enter a string:");
    scanf("%s",A);
    printf("ENTER THE WORD:");
    scanf("%s",B);


    cudaMalloc((void**)&d_A, strlen(A)*sizeof(char));
    cudaMalloc((void**)&d_B, strlen(B)*sizeof(char));
    cudaMalloc((void **)&d_count,sizeof(unsigned int));
    cudaMemcpy(d_A, A, strlen(A)*sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, strlen(B)*sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count,count,sizeof(unsigned int),cudaMemcpyHostToDevice);

    wordcount<<<1, strlen(A)-strlen(B)+1>>>(d_A, d_B, strlen(B), d_count);
    
    cudaMemcpy(result, d_count, sizeof(unsigned int), cudaMemcpyDeviceToHost);
    printf("Total occurences of %s=%u\n",B,*result);
    cudaFree(d_A);
    cudaFree(d_count);
    printf("\n");
    return 0;
}