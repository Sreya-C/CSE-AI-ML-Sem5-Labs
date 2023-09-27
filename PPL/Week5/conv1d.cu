#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void conv1D(float * N,float * M,float * P,float width,float mask_width)
{
	int tid = threadIdx.x + blockIdx.x*blockDim.x;
	int pvalue = 0,j,start_point = tid-(mask_width/2);
	for(j=0;j<mask_width;j++)
	{
		if(start_point+j >=0 && start_point+j<width)
			pvalue += N[start_point+j]*M[j];
	}
	P[tid] = pvalue;

}	


int main()
{	
	int width,mask_width;
	printf("Enter array width and mask width");
	scanf("%d",&width);
	scanf("%d",&mask_width);
	int arrsize = width*sizeof(float);
	int masksize = mask_width*sizeof(float);
	float *h_N = (float *)malloc(arrsize);
  	float *h_M = (float *)malloc(masksize);
  	float *h_P = (float *)malloc(arrsize);

  	float *d_N, *d_M, *d_P;
	cudaMalloc(&d_N, arrsize);
	cudaMalloc(&d_M, masksize);
	cudaMalloc(&d_P, arrsize);
	printf("Enter elements of array:");
	for(int i=0;i<width;i++) scanf("%f",h_N + i);
	cudaMemcpy(d_N,h_N,arrsize,cudaMemcpyHostToDevice);
	printf("Enter elements of mask:");
	for(int i=0;i<mask_width;i++) scanf("%f",h_M + i);
	cudaMemcpy(d_M,h_M,masksize,cudaMemcpyHostToDevice);

	conv1D<<<ceil(width/32),32>>>(d_N,d_M,d_P,width,mask_width);
	cudaMemcpy(h_P,d_P,arrsize,cudaMemcpyDeviceToHost);

	printf("Array: ");
	for(int i=0;i<width;i++)
	{
		printf("%d ",(int)h_N[i]);
	}

	printf("\nMask Array: ");
	for(int i=0;i<mask_width;i++)
	{
		printf("%d ",(int)h_M[i]);
	}

	printf("\nConvolved Array: ");
	for(int i=0;i<width;i++)
	{
		printf("%d ",(int)h_P[i]);
	}

	free(h_N);
	free(h_M);
	free(h_P);

	cudaFree(d_N);
	cudaFree(d_M);
	cudaFree(d_P);
}