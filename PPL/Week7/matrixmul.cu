#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void matrixmulrow(int * A, int * B, int * C, int WB,int WA)
{
	int ridA = threadIdx.x, HA = blockDim.x, sum = 0;
	if(ridA<HA)
	{
		for(int cidB = 0;cidB<WB;cidB++)
		{
			sum = 0;
			for(int k=0;k<WA;k++)
			{
				printf("%d,%d\n",A[ridA*WA + k],B[k*WB+cidB]);
				sum += A[ridA*WA + k]*B[k*WB+cidB];
			}
			printf("Sum = %d",sum);
			C[ridA*WB + cidB] = sum;
		}
	}
}

__global__ void matrixmulcol(int * A, int * B, int * C, int HA, int WA)
{
	int cidB = threadIdx.x, WB = blockDim.x, sum = 0;
	if(cidB<WB)
	{
		for(int ridA = 0;ridA<HA;ridA++)
		{
			sum = 0;
			for(int k=0;k<WA;k++)
			{
				sum += A[ridA*WA + k]*B[k*WB+cidB];
			}
			C[ridA*WB + cidB] = sum;
		}
	}
}

__global__ void matrixaddrc(int * A, int * B, int * C, int WA)
{
	int cidB = threadIdx.x, WB = blockDim.x;
	int ridA = threadIdx.y, HA = blockDim.y;
	int sum = 0;
	if(cidB<WB && ridA<HA)
	{
		for(int k=0;k<WA;k++)
		{
			sum += A[ridA*WA + k]*B[k*WB+cidB];
		}
		C[ridA*WB + cidB] = sum;
	}
}


int main()
{
	int A[100][100],linearA[500],linearB[500],B[100][100],C[100][100],linearC[500];
	int *d_A,*d_B,*d_C,WA,WB,HA,HB,matsizeA,matsizeB,matsizeC,index = 0;
	printf("Enter num of rows and num of columns of matrix A: ");
	scanf("%d %d",&HA,&WA);
	matsizeA = WA*HA*sizeof(int);
	printf("Enter matrix A of size %dx%d:\n",HA,WA);
	for(int i=0;i<HA;i++){
		for(int j=0;j<WA;j++){
			scanf("%d",&A[i][j]);
			linearA[index++] = A[i][j];
		}
	}
	printf("Enter num of rows and num of columns of matrix A: ");
	scanf("%d %d",&HB,&WB);
	matsizeB = WB*HB*sizeof(int);
	printf("Enter matrix B of size %dx%d:\n",HB,WB);
	index = 0;
	for(int i=0;i<HB;i++){
		for(int j=0;j<WB;j++){
			scanf("%d",&B[i][j]);
			linearB[index++] = B[i][j];
		}
	}

	matsizeC = HA*WB*sizeof(int);
	cudaMalloc((void**)&d_A,matsizeA);
	cudaMalloc((void**)&d_B,matsizeB);
	cudaMalloc((void**)&d_C,matsizeC);
	cudaMemcpy(d_A,linearA,matsizeA,cudaMemcpyHostToDevice);
	cudaMemcpy(d_B,linearB,matsizeB,cudaMemcpyHostToDevice);

	matrixmulrow<<<1,HA>>>(d_A,d_B,d_C,WB,WA);

	cudaMemcpy(linearC,d_C,matsizeC,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			C[i][j] = linearC[index++];
		}
	}
	printf("Product of the 2 matrices:\n");
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}

	matrixmulcol<<<1,WB>>>(d_A,d_B,d_C,HA,WA);

	cudaMemcpy(linearC,d_C,matsizeC,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			C[i][j] = linearC[index++];
		}
	}
	printf("Product of the 2 matrices:\n");
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}

	dim3 dimGrid(1,1,1);
	dim3 dimBlock(WB,HA,1);
	matrixaddrc<<<dimGrid,dimBlock>>>(d_A,d_B,d_C,WA);
	cudaMemcpy(linearC,d_C,matsizeC,cudaMemcpyDeviceToHost);
	index = 0;
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			C[i][j] = linearC[index++];
		}
	}
	printf("Product of the 2 matrices:\n");
	for(int i=0;i<HA;i++){
		for(int j=0;j<WB;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}
	cudaFree(d_A);cudaFree(d_B);cudaFree(d_C);
}