/*Write a CUDA program that reads a MXN matrix A and produces a resultant matrix B of 
same size as follows: Replace all the even numbered matrix elements with their row sum 
and odd numbered matrix elements with their column sum.
Example: A B
I/p: 1 2 3 O/p: 5 6 9
4 5 6 15 7 15*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void rowsum(int * A,int col,int * rowsums)
{
  int tid = threadIdx.x;
  int sum = 0;
  for(int i=0;i<col;i++)
  {
    sum += A[col*tid+i];
  }
  rowsums[tid] = sum;
  printf("At Row %d, rowsum = %d\n",tid,rowsums[tid]);
}

__global__ void colsum(int * A,int row,int * colsums)
{
  int tid = threadIdx.x,col = blockDim.x,sum = 0;
  colsums[tid] = 0;
  printf("Calculating colsum: ROWS %d,COLS %d,TID: %d\n",row,col,tid);
  for(int i=0;i<row;i++)
  {
    sum += A[i*col+tid];
    printf("%d,%d,%d\n",tid,i*col+tid,A[i*col+tid]);
  }
  colsums[tid] = sum;
  printf("At Col %d, colsum = %d\n",tid,colsums[tid]);
}

__global__ void replacemat(int * A, int * rowsums, int * colsums)
{
  int rid = threadIdx.y,cid = threadIdx.x;
  int row = blockDim.y,col = blockDim.x;
  int ele = A[rid*col+cid];
  if (ele%2==0) A[rid*col + cid] = rowsums[rid];
  else A[rid*col + cid] = colsums[cid];
}

int main()
{
  int *A,*rowsums,*colsums,row,col,matsize;
  int *d_A,*d_rowsums,*d_colsums;
  printf("Enter rowsize and colsize of matrix: ");
  scanf("%d %d",&row,&col);
  printf("%d %d",row,col);
  matsize = row*col*sizeof(int);
  A = (int *) malloc(matsize);
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
  replacemat<<<dimGrid,dimBlock>>>(d_A,d_rowsums,d_colsums);

  cudaMemcpy(A,d_A,matsize,cudaMemcpyDeviceToHost);
  printf("\nModified matrix: \n");
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%d ",A[i*col+j]);
    }
    printf("\n");
  }
}