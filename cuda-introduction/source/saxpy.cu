#include "common.h"

#include <device_launch_parameters.h>

#include <cmath>
#include <iostream>
#include <random>

__global__ void saxpy(float* const z, const float* const x, const float* const y, const float a, const unsigned size)
{
    // Compute the global index for each thread.
    // Assumptions: blockDim.y == 1 (so it's a N x 1 configuration of blocks), threadIdx.y == 1 (so it's a
    // N x 1 configuration of threads)
    unsigned idx = blockIdx.x * blockDim.x + threadIdx.x;

    // Check if idx is out of bounds. If yes, return.
    if (idx >= size)
        return;

    // Perform the SAXPY operation: z = a * x + y.
    z[idx] = a * x[idx] + y[idx];
}

int main(int argc, char *argv[])
{
    // Set the size. Start with something simple like 64.
    // Optional: Try out these sizes: 256, 1024, 2048, 14, 103, 1025, 3127
    const unsigned size = 257;

    // Host arrays.
    float* x = new float[size];
    float* y = new float[size];
    float* z = new float[size];

    // LOOK: We use this "gold" array to store the CPU result to be compared with GPU result
    float* z_gold = new float[size];

    // LOOK: Setup random number generator and fill host arrays and the scalar a.
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_real_distribution<float> dist(0.0, 1.0);

    // Fill matrix x and y, then a
    for (unsigned i = 0; i < size; i++) {
        x[i] = dist(mt);
        y[i] = dist(mt);
    }
    const float a = dist(mt);

    // Compute "gold" reference standard
    for (unsigned i = 0; i < size; i++)
        z_gold[i] = a * x[i] + y[i];

    // Device arrays
    float *d_x, *d_y, *d_z;
    size_t count = size * sizeof(float);

    // Allocate memory on the device.
    CUDA(cudaMalloc((void**) &d_x, count));
    CUDA(cudaMalloc((void**) &d_y, count));
    CUDA(cudaMalloc((void**) &d_z, count));

    // Copy array contents of X and Y from the host (CPU) to the device (GPU).
    CUDA(cudaMemcpy(d_x, x, count, cudaMemcpyHostToDevice));
    CUDA(cudaMemcpy(d_y, y, count, cudaMemcpyHostToDevice));

    CUDA(cudaDeviceSynchronize());

    ////////////////////////////////////////////////////////////
    std::cout << "****************************************************" << std::endl;
    std::cout << "***SAXPY***" << std::endl;

    // LOOK: Use the preprocess function to clear z and d_z
    clearHostAndDeviceArray(z, d_z, size);

    // Start threadPerBlock as 128, then try out differnt configurations: 32, 64, 256, 512, 1024
    // Use divup to get the number of blocks to launch.
    const unsigned threadsPerBlock = 128;

    const unsigned blocks = divup(size, threadsPerBlock);

    // Launch the GPU kernel with blocks and threadPerBlock as launch configuration
    saxpy<<<blocks, threadsPerBlock>>>(d_z, d_x, d_y, a, size);

    // Copy the answer back to the host (CPU) from the device (GPU).
    CUDA(cudaMemcpy(z, d_z, count, cudaMemcpyDeviceToHost));

    // LOOK: Use postprocess to check the result
    compareReferenceAndResult(z_gold, z, size, 1e-6);
    std::cout << "****************************************************" << std::endl << std::endl;
    ////////////////////////////////////////////////////////////

    // Free device memory using cudaFree
    CUDA(cudaFree(d_x));
    CUDA(cudaFree(d_y));
    CUDA(cudaFree(d_z));

    // free host memory
    delete[] x;
    delete[] y;
    delete[] z;
    delete[] z_gold;

    // successful program termination
    return 0;
}
