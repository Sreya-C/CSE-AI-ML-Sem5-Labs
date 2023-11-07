#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void rowmodify(int * A,int width)
{
	int ridA = threadIdx.x + blockIdx.x*blockDim.x;
	int ele;
	for(int cidA = 0;cidA < width;cidA++){
		ele = A[ridA*width + cidA];
		A[ridA*width + cidA] = powf(ele,ridA+1);
	}
}

int main()
{
	int A[100][100],linearA[10000];
	int * d_A, row, col,matsize,index = 0;
	printf("Enter no of rows and columns of matrix A: ");
	scanf("%d %d",&row,&col);
	matsize = row*col*sizeof(int);
	printf("Enter matrix A of size %dx%d:\n",row,col);
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			scanf("%d",&A[i][j]);
			linearA[index++] = A[i][j];
		}
	}

	cudaMalloc((void **)&d_A,matsize);
	cudaMemcpy(d_A,linearA,matsize,cudaMemcpyHostToDevice);

	rowmodify<<<1,row>>>(d_A,col);

	cudaMemcpy(linearA,d_A,matsize,cudaMemcpyDeviceToHost);

	printf("Resultant Matrix:\n");
	index = 0;
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			A[i][j] = linearA[index++];
			printf("%d ",A[i][j]);
		}
		printf("\n");
	}

	cudaFree(d_A);
}