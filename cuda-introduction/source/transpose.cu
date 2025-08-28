#include "common.h"

#include <device_launch_parameters.h>

#include <cmath>
#include <iostream>

/**
 * *****************************************************************************
 * README FIRST
 * In this example, we'll implement both a Copy Kernel and a Transpose Kernel.
 * The only difference in the two kernels is the index we use for the actual copy / transpose operation.
 * In copy, the destination index is same as source index. In transpose, the destination index is transpose of source index.
 * In this exercise, first get the copy kernel working correctly, which is simpler. Then move to transpose.
 * *****************************************************************************
 */

// TODO 6: Implement the copy kernel
__global__ void copyKernel(const float* const a, float* const b, const unsigned sizeX, const unsigned sizeY)
{
    // TODO 6a: Compute the global index for each thread along x and y dimentions.
    unsigned i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned j = blockIdx.y * blockDim.y + threadIdx.y;

    // TODO 6b: Check if i or j are out of bounds. If they are, return.
    if (i >= sizeX || j >= sizeY) return;

    // TODO 6c: Compute global 1D index from i and j
    unsigned index = i + sizeX * j;

    // TODO 6d: Copy data from A to B. Note that in copy kernel source and destination indices are the same
    // b[] = a[];
    b[index] = a[index];
}

// TODO 11: Implement the transpose kernel
// Start by copying everything from the copy kernel.
// Then make the change to compute different index_in and index_out from i and j
// Then change the final operation to use the correct index variables.
__global__ void matrixTransposeNaive(const float* const a, float* const b, const unsigned sizeX, const unsigned sizeY)
{
    // TODO 11a: Compute the global index for each thread along x and y dimentions.
    unsigned i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned j = blockIdx.y * blockDim.y + threadIdx.y;

    // TODO 11b: Check if i or j are out of bounds. If they are, return.
    if (i >= sizeX || j >= sizeY) return;

    // TODO 11c: Compute index_in as (i,j) (same as index in copy kernel) and index_out as (j,i)
    unsigned index_in  = i + sizeX * j;  // Compute input index (i,j) from matrix A
    unsigned index_out = j + sizeY * i;  // Compute output index (j,i) in matrix B = transpose(A)

    // TODO 11d: Copy data from A to B using transpose indices
    b[index_out] = a[index_in];
}

int main(int argc, char *argv[])
{
    // TODO 1: Initialize sizes. Start with simple like 32 x 32.
    // TODO Optional: Try different sizes - both square and non-square. Use these as examples:
    // 1024 x 1024, 2048 x 2048, 64 x 16, 128 x 768, 63 x 63, 31 x 15, 1025 x 1025, 1234 x 3153
    const unsigned sizeX = 32;
    const unsigned sizeY = 32;
    int sizeInBytes = sizeof(float) * sizeX * sizeY;

    // LOOK: Allocate host arrays. The gold arrays are used to store the results from CPU.
    float* a = new float[sizeX * sizeY];
    float* b = new float[sizeX * sizeY];
    float* a_gold = new float[sizeX * sizeY];
    float* b_gold = new float[sizeX * sizeY];

    // Fill matrix A
    for (unsigned i = 0; i < sizeX * sizeY; i++)
        a[i] = (float)i;

    // Compute "gold" reference standard
    for (unsigned jj = 0; jj < sizeY; jj++)
    {
        for (unsigned ii = 0; ii < sizeX; ii++)
        {
            a_gold[jj * sizeX + ii] = a[jj * sizeX + ii]; // Reference for copy kernel
            b_gold[ii * sizeY + jj] = a[jj * sizeX + ii]; // Reference for transpose kernel
        }
    }

    // Device arrays
    float *d_a, *d_b;

    // TODO 2: Allocate memory on the device for d_a and d_b.
    CUDA(cudaMalloc((void**)& d_a, sizeInBytes));
    CUDA(cudaMalloc((void**)& d_b, sizeInBytes));

    // TODO 3: Copy array contents of A from the host (CPU) to the device (GPU)
    CUDA(cudaMemcpy(d_a, a, sizeInBytes, cudaMemcpyHostToDevice));
    CUDA(cudaDeviceSynchronize());

    ////////////////////////////////////////////////////////////
    std::cout << "****************************************************" << std::endl;
    std::cout << "***Device To Device Copy***" << std::endl;
    {
        // LOOK: Use the clearHostAndDeviceArray function to clear b and d_b
        clearHostAndDeviceArray(b, d_b, sizeX * sizeY);

        // TODO 4: Assign a 2D distribution of BS_X x BS_Y x 1 CUDA threads within
        // Calculate number of blocks along X and Y in a 2D CUDA "grid" using divup
        DIMS dims;
        dims.dimBlock = dim3(16, 16, 1);
        dims.dimGrid = dim3(divup(sizeX, dims.dimBlock.x), divup(sizeY, dims.dimBlock.y), 1);

        // LOOK: Launch the copy kernel
        copyKernel<<<dims.dimGrid, dims.dimBlock>>>(d_a, d_b, sizeX, sizeY);

        // TODO 5: copy the answer back to the host (CPU) from the device (GPU)
        CUDA(cudaMemcpy(b, d_b, sizeInBytes, cudaMemcpyDeviceToHost));

        // LOOK: Use compareReferenceAndResult to check the result
        compareReferenceAndResult(a_gold, b, sizeX * sizeY);
    }
    std::cout << "****************************************************" << std::endl << std::endl;
    ////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////
    std::cout << "****************************************************" << std::endl;
    std::cout << "***Naive Transpose***" << std::endl;
    {
        // LOOK: Use the clearHostAndDeviceArray function to clear b and d_b
        clearHostAndDeviceArray(b, d_b, sizeX * sizeY);

        // TODO 8: Assign a 2D distribution of BS_X x BS_Y x 1 CUDA threads within
        // Calculate number of blocks along X and Y in a 2D CUDA "grid" using divup
        DIMS dims;
        dims.dimBlock = dim3(16, 16, 1);
        dims.dimGrid = dim3(divup(sizeX, dims.dimBlock.x), divup(sizeY, dims.dimBlock.y), 1);

        // TODO 9: Launch the matrix transpose kernel
        // matrixTransposeNaive<<<>>>(......);
        matrixTransposeNaive<<<dims.dimGrid, dims.dimBlock>>>(d_a, d_b, sizeX, sizeY);

        // TODO 10: copy the answer back to the host (CPU) from the device (GPU)
        CUDA(cudaMemcpy(b, d_b, sizeInBytes, cudaMemcpyDeviceToHost));

        // LOOK: Use compareReferenceAndResult to check the result
        compareReferenceAndResult(b_gold, b, sizeX * sizeY);
    }
    std::cout << "****************************************************" << std::endl << std::endl;
    ////////////////////////////////////////////////////////////

    // TODO 7: free device memory using cudaFree
    CUDA(cudaFree(d_a));
    CUDA(cudaFree(d_b));

    // free host memory
    delete[] a;
    delete[] b;

    // successful program termination
    return 0;
}
