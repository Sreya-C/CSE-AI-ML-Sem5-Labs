#include<stdio.h>
#include<cuda.h>
#include<stdlib.h>

__global__ void duplicate(char* sin, char *sout,int len)
{
  int tid = threadIdx.x;
  int n = blockDim.x;
  int si = tid*len;
  for(int i=0;i<len;i++)
  {
    sout[si++] = sin[i];
  }
}

int main()
{
  char * sin, * sout, *d_sin, * d_sout;
  int len,n,soutlen;

  
  printf("Enter number of times to repeat the string: ");
  scanf("%d",&n);
  sin = (char*) malloc(sizeof(char)*20);
  sout = (char*) malloc(sizeof(char)*20*n);
  printf("Enter string:");
  scanf("%s",sin);
  len = strlen(sin);
  soutlen = len*n;

  cudaMalloc((void**)&d_sin,sizeof(char)*len);
  cudaMalloc((void**)&d_sout,sizeof(char)*soutlen);
  cudaMemcpy(d_sin,sin,sizeof(char)*len,cudaMemcpyHostToDevice);

  duplicate<<<1,n>>>(d_sin,d_sout,len);
  cudaMemcpy(sout,d_sout,sizeof(char)*soutlen,cudaMemcpyDeviceToHost);

  printf("Modified String: %s",sout);

}