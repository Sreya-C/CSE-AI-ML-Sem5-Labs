#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#define STB_IMAGE_IMPLEMENTATION
#include "./stb_image.h"
#define STBI_MSC_SECURE_CRT
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "./stb_image_write.h"

#include <stdint.h>

#define BLOCK_WIDTH 32

__global__ void rgbToGray(unsigned char* img_in, unsigned char* img_out, int height, int width) {
    int rid = blockIdx.y * blockDim.y + threadIdx.y;
    int cid = blockIdx.x * blockDim.x + threadIdx.x;

    if(rid < height && cid < width) {
        int grayOffset = rid * width + cid;
        int rgbOffset = grayOffset * 3;
        unsigned char r=img_in[rgbOffset], g=img_in[rgbOffset+1], b=img_in[rgbOffset+2];
        img_out[rid*width+cid] = (unsigned char) (0.21f * r + 0.71f * g + 0.07f * b);
    }
}

__global__ void emboss(unsigned char* img_in, int* img_out, int height, int width, int* min, int* max) {
    int rid = blockIdx.y * blockDim.y + threadIdx.y;
    int cid = blockIdx.x * blockDim.x + threadIdx.x;

    if(rid < height && cid < width) {
        int gradX = 0, gradY = 0;
        
        if(cid - 1 >= 0) 
            gradX += img_in[rid*width+(cid-1)];
        if(cid + 1 < width)
            gradX -= img_in[rid*width+(cid+1)];
        
        if(rid - 1 >= 0) 
            gradY += img_in[(rid-1)*width+cid];
        if(rid + 1 < height)
            gradY -= img_in[(rid+1)*width+cid];
        
        int val = gradX + gradY;
        
        img_out[rid*width+cid] = val;
        atomicMin(min, val);
        atomicMax(max, val);
    }
}

__global__ void normalize(int* img_in, unsigned char* img_out, int height, int width, int min, int max) {
    int rid = blockIdx.y * blockDim.y + threadIdx.y;
    int cid = blockIdx.x * blockDim.x + threadIdx.x;

    if(rid < height && cid < width) {
        int offSet = rid * width + cid;
        img_out[offSet] = (unsigned char) ((img_in[offSet] - min) * 255 / (max - min));
    }
}


int main() {
    unsigned char *img_in, *img_out;
    int width, height, bpp, min=INT_MAX, max=INT_MIN;
    int sizeimgin, sizeimggray, sizeimgint, sizeimgout;

    unsigned char *d_img_in, *d_img_gray, *d_img_out;
    int *d_img_int, *d_min, *d_max; 

    img_in = stbi_load("lena.jpeg", &width, &height, &bpp, 0);

    sizeimgin = width * height * bpp * sizeof(unsigned char);
    sizeimggray = width * height * 1 * sizeof(unsigned char);
    sizeimgint = width * height * 1 * sizeof(int);
    sizeimgout = width * height * 1 * sizeof(unsigned char);

    img_out = (unsigned char*) malloc(sizeimgout);

    cudaMalloc((void**) &d_img_in, sizeimgin);
    cudaMalloc((void**) &d_img_gray, sizeimggray);
    cudaMalloc((void**) &d_img_int, sizeimgint);
    cudaMalloc((void**) &d_min, sizeof(int));
    cudaMalloc((void**) &d_max, sizeof(int));
    cudaMalloc((void**) &d_img_out, sizeimgout);

    cudaMemcpy(d_img_in, img_in, sizeimgin, cudaMemcpyHostToDevice);
    cudaMemcpy(d_min, &min, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_max, &max, sizeof(int), cudaMemcpyHostToDevice);
    
    dim3 gridDim(ceil((float)width/BLOCK_WIDTH), ceil((float)height/BLOCK_WIDTH));
    dim3 blockDim(BLOCK_WIDTH, BLOCK_WIDTH);

    rgbToGray<<<gridDim, blockDim>>>(d_img_in, d_img_gray, height, width);

    emboss<<<gridDim, blockDim>>>(d_img_gray, d_img_int, height, width, d_min, d_max);

    cudaMemcpy(&min, d_min, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&max, d_max, sizeof(int), cudaMemcpyDeviceToHost);

    normalize<<<gridDim, blockDim>>>(d_img_int, d_img_out, height, width, min, max);

    cudaMemcpy(img_out, d_img_out, sizeimgout, cudaMemcpyDeviceToHost);

    stbi_write_jpg("lena_emboss.jpg", width, height, 1, img_out, 100);

    cudaFree(d_img_in);
    cudaFree(d_img_gray);
    cudaFree(d_img_int);
    cudaFree(d_min);
    cudaFree(d_max);
    cudaFree(d_img_out);

    free(img_in);
    free(img_out);

    return 0;
}