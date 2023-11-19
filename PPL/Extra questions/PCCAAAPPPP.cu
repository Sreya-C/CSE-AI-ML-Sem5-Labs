#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>

__global__ void modify(char * str, char * rstr)
{
  int tid = threadIdx.x,currpos=0;

  for(int i=0;i<=tid;i++)
  {
    currpos += i;
  }
  for(int i=0;i<tid+1;i++)
  {
    rstr[currpos++] = str[tid]; 
  }
}

int main()
{
  char * str, * d_str, * rstr, * d_rstr;
  int len;

  str = (char * ) malloc(sizeof(char)*30);
  rstr = (char * ) malloc(sizeof(char)*60);
  printf("Enter a string: ");
  scanf("%s",str);
  len = strlen(str);
  cudaMalloc((void**)&d_str,sizeof(char)*len);
  cudaMalloc((void**)&d_rstr,sizeof(char)*len*(len+1)/2);
  cudaMemcpy(d_str,str,sizeof(char)*len,cudaMemcpyHostToDevice);

  modify<<<1,len>>>(d_str,d_rstr);

  cudaMemcpy(rstr,d_rstr,sizeof(char)*(len+1)*len/2,cudaMemcpyDeviceToHost);

  printf("Modified string: %s",rstr);
}