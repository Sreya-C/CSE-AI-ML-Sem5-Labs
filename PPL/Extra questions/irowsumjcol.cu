#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void rowsum(int * A,int col, int * rowsums)
{
  int rid = threadIdx.x,sum=0;
  for(int i=0;i<col;i++)
  {
    sum += A[rid*col+i];
  }
  rowsums[rid] = sum;
}

__global__ void colsum(int * A,int row, int * colsums)
{
  int cid = threadIdx.x,sum=0;
  int col = blockDim.x;
  for(int i=0;i<row;i++)
  {
    sum += A[i*col+cid];
  }
  colsums[cid] = sum;
}

__global__ void replacemat(int * rowsums, int * colsums,int *B)
{
  int rid = threadIdx.y,cid = threadIdx.x;
  int col = blockDim.x;
  B[rid*col + cid] = rowsums[rid]+colsums[cid];
}

int main()
{
  int *A,*rowsums,*colsums,row,col,matsize,*B;
  int *d_A,*d_rowsums,*d_colsums,*d_B;
  printf("Enter rowsize and colsize of matrix: ");
  scanf("%d %d",&row,&col);
  printf("%d %d",row,col);
  matsize = row*col*sizeof(int);
  A = (int *) malloc(matsize);
  B = (int *) malloc(matsize);
  rowsums = (int *) malloc(sizeof(int)*row);
  colsums = (int *) malloc(sizeof(int)*col);
  printf("Enter elements of matrix: \n");
  for(int i=0;i<row*col;i++)
  {
    scanf("%d",&A[i]);
  }
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%d",A[i*col+j]);
    }
    printf("\n");
  }
  cudaMalloc((void**)&d_A,matsize);
  cudaMalloc((void**)&d_B,matsize);
  cudaMalloc((void**)&d_rowsums,sizeof(int)*row);
  cudaMalloc((void**)&d_colsums,sizeof(int)*col);
  cudaMemcpy(d_A,A,matsize,cudaMemcpyHostToDevice);

  rowsum<<<1,row>>>(d_A,col,d_rowsums);
  colsum<<<1,col>>>(d_A,row,d_colsums);
  cudaDeviceSynchronize();
  cudaMemcpy(rowsums,d_rowsums,sizeof(int)*row,cudaMemcpyDeviceToHost);
  cudaMemcpy(colsums,d_colsums,matsize/row,cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();
  printf("ROWSUMS: \n");
  for(int i=0;i<row;i++)
  {
    printf("%d ",rowsums[i]);
  }
  printf("\nCOLSUMS: \n");  
  for(int i=0;i<col;i++)
  {
    printf("%d ",colsums[i]);
  }

  dim3 dimGrid(1,1,1);
  dim3 dimBlock(col,row,1);
  replacemat<<<dimGrid,dimBlock>>>(d_rowsums,d_colsums,d_B);

  cudaMemcpy(B,d_B,matsize,cudaMemcpyDeviceToHost);
  printf("\nModified matrix: \n");
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%d ",B[i*col+j]);
    }
    printf("\n");
  }
}
