#include <stdio.h>

// Define matrix dimensions and kernel dimensions
#define WIDTH 4
#define HEIGHT 4
#define KERNEL_SIZE 3

// CUDA kernel for 2D convolution
__global__ void convolution2D(int *input, int *mask, int *output, int width, int height, int kernelSize)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < height && col < width)
    {
        int sum = 0;
        int offset = kernelSize / 2;
        for (int i = 0; i < kernelSize; i++)
        {
            for (int j = 0; j < kernelSize; j++)
            {
                int r = row + i - offset;
                int c = col + j - offset;

                if (r >= 0 && r < height && c >= 0 && c < width)
                {
                    sum += input[r * width + c] * mask[i * kernelSize + j];
                }
            }
        }

        output[row * width + col] = sum;
    }
}

int main()
{
    int input[HEIGHT][WIDTH];                                               
    int mask[KERNEL_SIZE][KERNEL_SIZE] = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}}; 
    int output[HEIGHT][WIDTH];                                                                                                                                                   

    int *d_input, *d_mask, *d_output;

    // Initialize input matrix (for simplicity)
    for (int i = 0; i < HEIGHT; i++)
    {
        for (int j = 0; j < WIDTH; j++)
        {
            input[i][j] = 1;
        }
    }
 
    // Allocate memory on the device
    cudaMalloc((void **)&d_input, WIDTH * HEIGHT * sizeof(int));
    cudaMalloc((void **)&d_mask, KERNEL_SIZE * KERNEL_SIZE * sizeof(int));
    cudaMalloc((void **)&d_output, WIDTH * HEIGHT * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(d_input, input, WIDTH * HEIGHT * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, KERNEL_SIZE * KERNEL_SIZE * sizeof(int), cudaMemcpyHostToDevice);

    // Define grid and block dimensions
    dim3 dimGrid((WIDTH + 15) / 16, (HEIGHT + 15) / 16);
    dim3 dimBlock(16, 16);

    // Launch the CUDA kernel
    convolution2D<<<dimGrid, dimBlock>>>(d_input, d_mask, d_output, WIDTH, HEIGHT, KERNEL_SIZE);

    // Copy the result back to the host
    cudaMemcpy(output, d_output, WIDTH * HEIGHT * sizeof(int), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_input);
    cudaFree(d_mask);
    cudaFree(d_output);

    printf("Input Matrix:\n");
    // Print the input matrix
    for (int i = 0; i < HEIGHT; i++)
    {
        for (int j = 0; j < WIDTH; j++)
        {
            printf("%d\t", input[i][j]);
        }
        printf("\n");
    }

    printf("Mask:\n");
    // Print the input matrix
    for (int i = 0; i < KERNEL_SIZE; i++)
    {
        for (int j = 0; j < KERNEL_SIZE; j++)
        {
            printf("%d\t", mask[i][j]);
        }
        printf("\n");
    }

    printf("Output Matrix:\n");
    // Print the output matrix
    for (int i = 0; i < HEIGHT; i++)
    {
        for (int j = 0; j < WIDTH; j++)
        {
            printf("%d\t", output[i][j]);
        }
        printf("\n");
    }
    return 0;
}