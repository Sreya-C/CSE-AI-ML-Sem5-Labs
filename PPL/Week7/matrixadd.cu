#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void matrixaddrow(int * A, int * B, int * C, int col)
{
	int rid = threadIdx.x;
	int row = blockDim.x;
	if(rid<row)
	{
		for(int cid=0;cid<col;cid++)
		{	
			C[rid*col+cid] = A[rid*col+cid] + B[rid*col+cid];
		}
	}
}

__global__ void matrixaddcol(int * A, int * B, int * C, int row)
{
	int cid = threadIdx.x;
	int col = blockDim.x;
	if(cid<col)
	{
		for(int rid = 0;rid<row;rid++)
		{
			C[rid*col+cid] = A[rid*col+cid] + B[rid*col+cid];
		}
	}
}

__global__ void matrixaddrc(int * A, int * B, int * C)
{
	int cid = threadIdx.x, col = blockDim.x;
	int rid = threadIdx.y, row = blockDim.y;
	if(cid<col && rid<row)
	{
		C[rid*col+cid] = A[rid*col+cid] + B[rid*col+cid];
	}
}


int main()
{
	int A[100][100],linearA[500],linearB[500],B[100][100],C[100][100],linearC[500];
	int *d_A,*d_B,*d_C,row,col,matsize,index = 0;
	printf("Enter num of rows and num of columns of matrices: ");
	scanf("%d %d",&row,&col);
	matsize = row*col*sizeof(int);
	printf("Enter matrix A of size %dx%d:\n",row,col);
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			scanf("%d",&A[i][j]);
			linearA[index++] = A[i][j];
		}
	}
	printf("Enter matrix B of size %dx%d:\n",row,col);
	index = 0;
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			scanf("%d",&B[i][j]);
			linearB[index++] = B[i][j];
		}
	}
	cudaMalloc((void**)&d_A,matsize);
	cudaMalloc((void**)&d_B,matsize);
	cudaMalloc((void**)&d_C,matsize);
	cudaMemcpy(d_A,linearA,matsize,cudaMemcpyHostToDevice);
	cudaMemcpy(d_B,linearB,matsize,cudaMemcpyHostToDevice);

	matrixaddrow<<<1,row>>>(d_A,d_B,d_C,col);

	printf("Each row in a separate thread: \n");
	cudaMemcpy(linearC,d_C,matsize,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			C[i][j] = linearC[index++];
		}
	}
	printf("Sum of the 2 matrices:\n");
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}

	matrixaddcol<<<1,col>>>(d_A,d_B,d_C,row);
	printf("Each col in a separate thread: \n");
	cudaMemcpy(linearC,d_C,matsize,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			C[i][j] = linearC[index];
			index += 1;
		}
	}
	printf("Sum of the 2 matrices:\n");
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}

	dim3 dimGrid(1,1,1);
	dim3 dimBlock(col,row,1);
	matrixaddrc<<<dimGrid,dimBlock>>>(d_A,d_B,d_C);
	printf("Each element in a separate thread: \n");
	cudaMemcpy(linearC,d_C,matsize,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			C[i][j] = linearC[index++];
		}
	}
	printf("Sum of the 2 matrices:\n");
	for(int i=0;i<row;i++){
		for(int j=0;j<col;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}
	cudaFree(d_A);cudaFree(d_B);cudaFree(d_C);
}