#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>	
#include<stdlib.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image/stb_image.h"
#define STBI_MSC_SECURE_CRT
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image/stb_image_write.h"
#include <stdint.h>
#define THREADS 32
__global__ void rgbToGray(unsigned char *in,unsigned char *out,int width,int height)
{
	int Col = blockDim.x*blockIdx.x+threadIdx.x;
	int Row = blockDim.y * blockIdx.y + threadIdx.y;
	if (Col < width && Row < height)
	{
		int grayOffset = Row * width + Col;
		int rgbOffset = grayOffset * 3;
		unsigned char r = in[rgbOffset];
		unsigned char g = in[rgbOffset + 1];
		unsigned char b = in[rgbOffset + 2];
		out[grayOffset] =(unsigned char) (0.21f * r + 0.71f * g + 0.07f * b);
	}
}
int main() {
	unsigned char* h_N;
	unsigned char* d_N;
	unsigned char* d_out;
	cudaError_t cudaStatus;
	int width, height, bpp;
	unsigned char* rgb_image = stbi_load("Lena.jpeg", &width, &height, &bpp, 0);
	h_N = (unsigned char*)malloc(width * height * bpp * sizeof(unsigned char));
	h_N = rgb_image;
	unsigned char* h_out= (unsigned char*)malloc(width * height * bpp * sizeof(unsigned char));
	cudaStatus = cudaMalloc((void**)&d_N, sizeof(unsigned char) * width*height*bpp);
	printf("%d", cudaStatus);
	cudaStatus = cudaMalloc((void**)&d_out, sizeof(unsigned char) * width *height*bpp);
	printf("%d", cudaStatus);
	cudaStatus = cudaMemcpy(d_N, h_N, width*height*bpp * sizeof(unsigned char), cudaMemcpyHostToDevice);
	printf("%d", cudaStatus);
	dim3 dimBlock(THREADS, THREADS);
	dim3 dimGrid((width + dimBlock.x - 1) / dimBlock.x, (height + dimBlock.y - 1) / dimBlock.y);
	rgbToGray << < dimGrid,dimBlock >> > (d_N, d_out, width, height);
	cudaDeviceSynchronize();
	cudaStatus = cudaMemcpy(h_out, d_out, width*height, cudaMemcpyDeviceToHost);
	printf("%d", cudaStatus);
	stbi_write_jpg("Lena_gray.jpg", width, height, 1, h_out, width*3);
	cudaFree(d_N);
	cudaFree(d_out);
	return 0;
}


