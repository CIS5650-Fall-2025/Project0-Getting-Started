#include <cstdio>
#include <cuda_runtime.h>

/**
 * LOOK: This is a macro that calls a CUDA function and checks for errors
 */
#define CUDA(call) do {                             \
    cudaError_t e = (call);                         \
    if (e == cudaSuccess) break;                    \
    fprintf(stderr, __FILE__":%d: %s (%d)\n",       \
            __LINE__, cudaGetErrorString(e), e);    \
    exit(1);                                        \
} while (0)

/**
 * LOOK: Use DIMS as a struct to store launch configurations.
 * dimBlock is dimension of block (threads), and dimGrid is dimension of the launch (number of blocks).
 * dim3 is a CUDA provided type, which as 3 components - x, y, z, which are initialized by default to 1.
 */
struct DIMS
{
    dim3 dimBlock;
    dim3 dimGrid;
};

/**
 * Function to divide up a size into part, each of div size. Similar to ceil.
 * Returns the number of parts.
 * Example, divup(10, 3) = 4
 */
unsigned divup(unsigned size, unsigned div);

/**
 * Function to set a host and device array to value (-1.0 as default).
 */
void clearHostAndDeviceArray(float *res, float *dev_res, unsigned size, const int value = 0);

/**
 * Function to check a reference and result array, optionally within an epsilon.
 * Return true if results match. Otherwise return false.
 */
bool compareReferenceAndResult(const float *ref, const float *res, unsigned size, float epsilon = 0.0f);
