#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

__global__ void transpose(int * mat, int *rmat)
{
  int rid = threadIdx.y;
  int cid = threadIdx.x;
  int row = blockDim.y,col = blockDim.x;
  rmat[cid*row+rid] = mat[rid*col+cid];
}

int main()
{
  int *mat,*d_mat,*rmat,*d_rmat;
  int row,col;
  printf("Enter row and column size: ");
  scanf("%d %d",&row,&col);
  mat = (int *) malloc(row*col*sizeof(int));
  rmat = (int *) malloc(row*col*sizeof(int));
  printf("Enter %dx%d matrix: \n",row,col);
  for(int i=0;i<row*col;i++)
  {
    scanf("%d",&mat[i]);
  }
  cudaMalloc((void**)&d_mat,sizeof(int)*row*col);
  cudaMalloc((void**)&d_rmat,sizeof(int)*row*col);
  cudaMemcpy(d_mat,mat,sizeof(int)*row*col,cudaMemcpyHostToDevice);

  dim3 dimGrid(1,1,1);
  dim3 dimBlock(col,row,1);

  transpose<<<dimGrid,dimBlock>>>(d_mat,d_rmat);
  cudaMemcpy(rmat,d_rmat,sizeof(int)*row*col,cudaMemcpyDeviceToHost);

  for(int i=0;i<col;i++)
  {
    for(int j=0;j<row;j++)
    {
      printf("%d",rmat[i*row+j]);
    }
    printf("\n");
  }

}