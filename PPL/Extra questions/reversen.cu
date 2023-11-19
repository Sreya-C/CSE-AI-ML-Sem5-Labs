#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>

__global__ void reversen(char * str, int * si)
{
  int tid = threadIdx.x;
  printf("\nTID: %d, starting index of tid %d",tid,si[tid]);
  int start_ind = si[tid];
  int end_ind = si[tid+1] - 1;
  int len = (end_ind - start_ind)/2 ;
  if(len==1) return;
  printf("TID: %d, Start Index: %d, End Index: %d, Length = %d\n",tid,start_ind,end_ind,len);
  for (int i = 0; i < len; i++) 
  { 
    int temp = str[start_ind + i]; 
    str[start_ind + i] = str[end_ind - i - 1];
    str[end_ind - i - 1] = temp;
  }
}

int main()
{
  char *str, * d_str;
  int len,ind=0,i;
  int *si,*d_si;
  str = (char * ) malloc(sizeof(char)*50);
  si = (int * ) malloc(sizeof(int)*20);
  printf("Enter a string of words: ");
  scanf("%[^\n]s",str);
  len = strlen(str);
  si[ind++] = 0;
  for(i=0;i<len;i++)
  {
    if(str[i] == ' ')
    {
      si[ind++] = i+1;
    }
  }
  si[ind] = i+1;
  int numWords = ind;
  for(int j=0;j<numWords+2;j++)
  {
    printf("%d ",si[j]);
  }
  cudaMalloc((void**)&d_str,sizeof(char)*len);
  cudaMalloc((void**)&d_si,sizeof(int)*(numWords+1));
  cudaMemcpy(d_str,str,sizeof(char)*len,cudaMemcpyHostToDevice);
  cudaMemcpy(d_si,si,sizeof(int)*(numWords+1),cudaMemcpyHostToDevice);

  reversen<<<1,numWords>>>(d_str,d_si);
  cudaMemcpy(str,d_str,sizeof(char)*(len),cudaMemcpyDeviceToHost);

  printf("Modified string: %s",str);
}

