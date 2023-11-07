#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cuda_runtime.h>

__global__ void oddKernel(int * A)
{
	int tid = threadIdx.x;
	if((tid%2!=0) && tid < (blockDim.x - 1))
	{
		if(A[tid]>A[tid+1])
		{
			int temp = A[tid];
			A[tid] = A[tid+1];
			A[tid+1] = temp;
		}
	}
}

__global__ void evenKernel(int * A)
{
	int tid = threadIdx.x;
	if((tid%2==0) && tid < (blockDim.x - 1))
	{
		if(A[tid]>A[tid+1])
		{
			int temp = A[tid];
			A[tid] = A[tid+1];
			A[tid+1] = temp;
		}
	}
}

int main()
{
	int size;
	printf("Enter size of array: ");
	scanf("%d",&size);
	int A[size];
	printf("Enter %d elements of array: ",size);
	for(int i=0;i<size;i++) scanf("%d",&A[i]);
	int * d_A;
	
	cudaMalloc((void**)&d_A,sizeof(int)*size);
	cudaMemcpy(d_A,A,sizeof(int)*size,cudaMemcpyHostToDevice);
	for(int i=0;i<=size/2;i++)
	{
		oddKernel<<<1,size>>>(d_A);
		evenKernel<<<1,size>>>(d_A);
	}
	cudaMemcpy(A,d_A,sizeof(int)*size,cudaMemcpyDeviceToHost);
	printf("Sorted Array: ");
	for(int i=0;i<size;i++) printf("%d ",A[i]);
}
