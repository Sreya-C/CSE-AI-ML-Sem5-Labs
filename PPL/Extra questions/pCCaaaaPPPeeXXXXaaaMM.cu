#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <string.h>

__global__ void corr(char *A,int*cumul,int *B,char * rstr)
{
  int rid = threadIdx.y,cid = threadIdx.x;
  int col = blockDim.x;
  int si = (cumul[rid*col+cid]-B[rid*col+cid])> 0 ? cumul[rid*col+cid -1] : 0;
  int ei = cumul[rid*col+cid];
  for(int i=si;i<ei;i++)
  {
    rstr[i] = A[rid*col+cid];
  }
}

int main()
{
  char *A,*rstr,*d_rstr,*d_A;
  int *B,*cumul,*d_cumul,*d_B,row,col,size;
  printf("Enter matrix dimensions: ");
  scanf("%d %d",&row,&col);
  size = row*col*sizeof(int);
  A = (char*) malloc(sizeof(char)*row*col);
  B = (int*) malloc(size);
  cumul = (int*) malloc(size);
  fflush(stdin);
  printf("Enter character matrix:");
  fflush(stdin);
  scanf("%c",&A[0]);
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      scanf("%c",&A[i*col+j]);
      fflush(stdin);
    }
  }
  fflush(stdin);
  printf("Character Matrix: \n");
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%c ",A[i*col+j]);
    }
    printf("\n");
  }
  printf("Enter number matrix: \n");
  int sum = 0;
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      scanf("%d",&B[i*col+j]);
      sum += B[i*col+j];
      cumul[i*col+j] = sum;
    }
  }
  printf("Number Matrix: \n");
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%d",B[i*col+j]);
    }
    printf("\n");
  }
  printf("Cumulative Sums Matrix: \n");
  for(int i=0;i<row;i++)
  {
    for(int j=0;j<col;j++)
    {
      printf("%d ",cumul[i*col+j]);
    }
    printf("\n");
  }
  int rstrlen = cumul[row*col-1];
  rstr = (char*) malloc(sizeof(char)*(rstrlen));
  cudaMalloc((void**)&d_A,sizeof(char)*row*col);
  cudaMalloc((void**)&d_B,size);
  cudaMalloc((void**)&d_cumul,size);
  cudaMalloc((void**)&d_rstr,sizeof(char)*(rstrlen));
  cudaMemcpy(d_A,A,sizeof(char)*row*col,cudaMemcpyHostToDevice);
  cudaMemcpy(d_B,B,size,cudaMemcpyHostToDevice);
  cudaMemcpy(d_cumul,cumul,size,cudaMemcpyHostToDevice);
  dim3 dimGrid(1,1,1);
  dim3 dimBlock(col,row,1);
  corr<<<dimGrid,dimBlock>>>(d_A,d_cumul,d_B,d_rstr);
  cudaMemcpy(rstr,d_rstr,sizeof(char)*(rstrlen),cudaMemcpyDeviceToHost);

  printf("Formed String: %s",rstr);
}