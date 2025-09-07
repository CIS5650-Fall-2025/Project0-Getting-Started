#include "common.h"
#include "termcolor.hpp"

#include <algorithm>
#include <cmath>
#include <iostream>

unsigned divup(unsigned size, unsigned div)
{
    // TODO: implement a 1 line function to return the divup operation.
    // Note: You only need to use addition, subtraction, and division operations.
    return (size + div - 1) / div;
}

void clearHostAndDeviceArray(float *res, float *dev_res, unsigned size, const int value)
{
    std::fill(res, res + size, value);

    // LOOK: See how we fill the array with the same number to clear it.
    CUDA(cudaMemset(dev_res, value, size * sizeof(float)));
}

// Check errors
bool compareReferenceAndResult(const float *ref, const float *res, unsigned size, float epsilon)
{
    bool passed = true;
    for (unsigned i = 0; i < size; i++)
    {
        // LOOK: Check if floating point values are equal within an epsilon as returns can vary slightly between CPU and GPU
        if (std::fabs(res[i] - ref[i]) > epsilon)
        {
            std::cout << "ID: " << i << " \t Res: " << res[i] << " \t Ref: " << ref[i] << std::endl;
            std::cout << termcolor::blink << termcolor::white << termcolor::on_red << "*** FAILED ***" << termcolor::reset << std::endl;
            passed = false;
            break;
        }
    }

    if (passed)
        std::cout << termcolor::green << "Post process check passed!!" << termcolor::reset << std::endl;

    return passed;
}

