#include "common.h"

#include <device_launch_parameters.h>

#include <cmath>
#include <iostream>
#include <random>

__global__ void saxpy(float* const z, const float* const x, const float* const y, const float a, const unsigned size)
{
    // TODO 9: Compute the global index for each thread.
    unsigned idx = 0;
	idx = threadIdx.x + blockIdx.x * blockDim.x;

    // TODO 10: Check if idx is out of bounds. If yes, return.
	if (idx >= size) return;

    // TODO 11: Perform the SAXPY operation: z = a * x + y.
	z[idx] = a * x[idx] + y[idx];
}

int main(int argc, char *argv[])
{
    // TODO 1: Set the size. Start with something simple like 64.
    // TODO Optional: Try out these sizes: 256, 1024, 2048, 14, 103, 1025, 3127
    const unsigned size = 3127;

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

    // TODO 2: Allocate memory on the device. Fill in the blanks for d_x, then do the same commands for d_y and d_z.
    // CUDA(cudaMalloc((void **)& pointer, size in bytes)));
	CUDA(cudaMalloc((void**)&d_x, size * sizeof(float)));
	CUDA(cudaMalloc((void**)&d_y, size * sizeof(float)));
	CUDA(cudaMalloc((void**)&d_z, size * sizeof(float)));

    // TODO 3: Copy array contents of X and Y from the host (CPU) to the device (GPU). Follow what you did for 2,
    // CUDA(cudaMemcpy(dest ptr, source ptr, size in bytes, direction enum));
	CUDA(cudaMemcpy(d_x, x, size * sizeof(float), cudaMemcpyHostToDevice));
	CUDA(cudaMemcpy(d_y, y, size * sizeof(float), cudaMemcpyHostToDevice));

    CUDA(cudaDeviceSynchronize());

    ////////////////////////////////////////////////////////////
    std::cout << "****************************************************" << std::endl;
    std::cout << "***SAXPY***" << std::endl;

    // LOOK: Use the preprocess function to clear z and d_z
    clearHostAndDeviceArray(z, d_z, size);

    // TODO 4: Setup threads and blocks.
    // Start threadPerBlock as 128, then try out differnt configurations: 32, 64, 256, 512, 1024
    // Use divup to get the number of blocks to launch.
    const unsigned threadsPerBlock = 128;

    // TODO 5: Implement the divup function in common.cpp
    const unsigned blocks = divup(size, threadsPerBlock);

    // TODO 6: Launch the GPU kernel with blocks and threadPerBlock as launch configuration
    // saxpy<<< >>> (....);
	saxpy<<<blocks, threadsPerBlock>>> (d_z, d_x, d_y, a, size);

    // TODO 7: Copy the answer back to the host (CPU) from the device (GPU).
    // Copy what you did in 3, except for d_z -> z.
	CUDA(cudaMemcpy(z, d_z, size * sizeof(float), cudaMemcpyDeviceToHost));

    // LOOK: Use postprocess to check the result
    compareReferenceAndResult(z_gold, z, size, 1e-6);
    std::cout << "****************************************************" << std::endl << std::endl;
    ////////////////////////////////////////////////////////////

    // TODO 8: free device memory using cudaFree
    // CUDA(cudaFree(device pointer));
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
